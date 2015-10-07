require 'base64'
require 'aws_helpers/utilities/polling'

include AwsHelpers::Utilities

module AwsHelpers
  module Actions
    module EC2

      class PollInstanceHealthy

        include AwsHelpers::Utilities::Polling

        def initialize(instance_id, options = {})
          @instance_id = instance_id
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay] || 15
          @max_attempts = options[:max_attempts] || 8
        end

        def execute
          poll(@delay, @max_attempts) {
            client = Aws::EC2::Instance.new(@instance_id)
            current_state = client.state.name
            @stdout.puts "Instance State is #{current_state}."

            if client.platform == 'windows'
              output = client.console_output.output
              unless output.nil?
                output = Base64.decode64(output)
              end
              ready = !!(output =~ /Windows is Ready to use/)
            end

            current_state == 'running' && ready

          }
        end

      end
    end
  end
end
