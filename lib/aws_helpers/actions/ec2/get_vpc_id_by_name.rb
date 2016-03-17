require 'aws-sdk-core'

module AwsHelpers
  module Actions
    module EC2

      class GetVpcIdByName

        def initialize(config, vpc_name, options)
          @config = config
          @vpc_name = vpc_name
          @stdout = options[:stdout] || $stdout
        end

        def get_id
          client = @config ? @config.aws_ec2_client : Aws::EC2::Client.new()
          response = client.describe_vpcs(filters: [
              {name: 'tag:Name', values: [@vpc_name]}
          ])
          response.vpcs.first.vpc_id unless response.vpcs.empty?
        end

      end

    end
  end
end