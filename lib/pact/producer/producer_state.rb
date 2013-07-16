module Pact
  module Producer

    module DSL
      def producer_state name, &block
        Pact::Producer::ProducerState.producer_state(name, &block).register
      end

      def producer_module name
        ProducerState.current_namespaces << name
        yield
        ProducerState.current_namespaces.pop
      end
    end

    class ProducerState

      attr_accessor :name
      attr_accessor :namespace

      def self.producer_state name, &block
        ProducerState.new(name, current_namespaces.join('.'), &block)
      end

      def self.register name, producer_state
        producer_states[name] = producer_state
      end

      def self.producer_states
        @@producer_states ||= {}
      end

      def self.current_namespaces
        @@current_namespaces ||= []
      end

      def self.get name
        producer_states[name] || producer_states[name.to_sym]
      end

      def register
        self.class.register(namespaced(name), self)
      end

      def initialize name, namespace, &block
        @name = name
        @namespace = namespace
        instance_eval(&block)
      end

      def set_up &block
        if block_given?
          @set_up_block = block
        elsif @set_up_block
          instance_eval &@set_up_block
        end
      end

      def tear_down &block
        if block_given?
          @tear_down_block = block
        elsif @tear_down_block
          instance_eval &@tear_down_block
        end
      end

      private

      def namespaced(name)
        if namespace.empty?
          name
        else
          "#{namespace}.#{name}"
        end
      end
    end
  end
end

#Include this into the global namespace the same way RSpec does
extend Pact::Producer::DSL
Module.send(:include, Pact::Producer::DSL)
