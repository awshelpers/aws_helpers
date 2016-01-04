require 'base64'
require 'aws_helpers/utilities/polling'

include AwsHelpers::Utilities

module AwsHelpers
  module Actions
    module EC2

      class PollInstanceHealthy

        include AwsHelpers::Utilities::Polling

        def initialize(config, instance_id, options = {})
          @config = config
          @instance_id = instance_id
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay] || 15
          @max_attempts = options[:max_attempts] || 8
        end

        def execute
          poll(@delay, @max_attempts) {
            ready = false
            client = @config.aws_ec2_client
            response = client.describe_instance_status(
                {
                    instance_ids: [@instance_id]
                }
            )
            unless response.instance_statuses[0].nil?
              state = response.instance_statuses[0].instance_state.name
              status = response.instance_statuses[0].instance_status.status
              @stdout.print "Instance State is #{state}.\tInstance Status is #{status}.\n"
              ready = true if state == 'running' && status == 'ok'
            end
            ready
          }
        end

      end
    end
  end
end

