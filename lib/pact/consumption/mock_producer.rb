require 'uri'

module Pact
  module Consumption
    class MockProducer

      attr_reader :uri

      def initialize(name)
        @name = name
      end

      def at(url)
        @uri = URI(url)
        self
      end

      def upon_receiving(request)
        Interaction.new(self, request)
      end

    end
  end
end