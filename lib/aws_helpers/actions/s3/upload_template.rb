require 'aws_helpers/actions/s3/exists'
require 'aws_helpers/actions/s3/create'
require 'aws_helpers/actions/s3/template_url'

module AwsHelpers
  module Actions
    module S3

      class S3UploadTemplate

        def initialize(config, stack_name, template_json, s3_bucket_name, bucket_encrypt, stdout = $stdout)
          @config = config
          @stack_name = stack_name
          @template_json = template_json
          @s3_bucket_name = s3_bucket_name
          @bucket_encrypt = bucket_encrypt
          @stdout = stdout
        end

        def execute
          s3_client = @config.aws_s3_client

          request = {
              bucket: @s3_bucket_name,
              key: @stack_name,
              body: @template_json,
          }
          request.merge!(server_side_encryption: 'AES256') if @bucket_encrypt

          @stdout.puts "Uploading #{@stack_name} to S3 bucket #{@s3_bucket_name}"

          AwsHelpers::Actions::S3::S3Create.new(@config, @s3_bucket_name, 'private').execute if ! AwsHelpers::Actions::S3::S3Exists.new(@config, @s3_bucket_name).execute

          s3_client.put_object(
              request
          )

          AwsHelpers::Actions::S3::S3TemplateUrl.new(@config, @s3_bucket_name).execute
        end

      end

    end
  end
end