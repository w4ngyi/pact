require 'pact/provider/print_missing_provider_states'
require 'rspec/core/formatters'
require 'colored'

module Pact
  module Provider
    module RSpec
      class Formatter < ::RSpec::Core::Formatters::DocumentationFormatter


        def dump_commands_to_rerun_failed_examples
          return if failed_examples.empty?

          print_rerun_commands
          print_failure_message
          print_missing_provider_states

        end

        def print_rerun_commands
          output.puts("\n")
          interaction_failure_messages.each do | message |
            output.puts(message)
          end
        end

        def print_missing_provider_states
          PrintMissingProviderStates.call Pact.world.provider_states.missing_provider_states, output
        end

        def interaction_failure_messages
          failed_examples.collect do |example|
            interaction_failure_message_for example
          end.uniq
        end

        def interaction_failure_message_for example
          provider_state = example.metadata[:pact_interaction].provider_state
          description = example.metadata[:pact_interaction].description
          pactfile_uri = example.metadata[:pactfile_uri]
          example_description = example.metadata[:pact_interaction_example_description]
          failure_color("rake pact:verify:at[#{pactfile_uri}] PACT_DESCRIPTION=\"#{description}\" PACT_PROVIDER_STATE=\"#{provider_state}\"") + " " + detail_color("# #{example_description}")
        end

        def print_failure_message
          output.puts failure_message
        end

        def failure_message

          "\n" + "For assistance debugging failures, please note:".underline.yellow + "\n\n" +
          "The pact files have been stored locally in the following temp directory:\n #{Pact.configuration.tmp_dir}\n\n" +
          "The requests and responses are logged in the following log file:\n #{Pact.configuration.log_path}\n\n"
        end

      end

    end

  end
end


