require 'aws_helpers/actions/ec2/poll_instance_stopped'

module AwsHelpers
  module Actions
    module EC2

      class InstanceStop

        def initialize(config, instance_id, options)
          @config = config
          @instance_id = instance_id
          @stdout = options[:stdout] || $stdout
          @instance_stopped_options = create_instance_stopped_options(@stdout, options[:poll_stopped])
        end

        def execute
          @stdout.puts("Stopping #{@instance_id}")
          client = @config.aws_ec2_client
          client.stop_instances(instance_ids: [@instance_id])
          AwsHelpers::Actions::EC2::PollInstanceStopped.new(@instance_id, @instance_stopped_options).execute
        end

        def create_instance_stopped_options(stdout, polling)
          options = {}
          options[:stdout] = stdout
          if polling
            max_attempts = polling[:max_attempts]
            delay = polling[:delay]
            options[:max_attempts] = max_attempts if max_attempts
            options[:delay] = delay if delay
          end
          options
        end

      end
    end
  end
end