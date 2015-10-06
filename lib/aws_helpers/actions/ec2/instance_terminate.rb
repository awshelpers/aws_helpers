module AwsHelpers
  module Actions
    module EC2

      class InstanceTerminate

        def initialize(config, instance_id, stdout = $stdout)
          @config = config
          @instance_id = instance_id
          @stdout = stdout
        end

        def execute
          @stdout.puts("Terminating #{@instance_id}")
          client = @config.aws_ec2_client
          client.terminate_instances(instance_ids: [@instance_id])
        end

      end
    end
  end
end