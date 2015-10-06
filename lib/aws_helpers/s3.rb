require_relative 'client'
require_relative 'actions/s3/create'
require_relative 'actions/s3/exists'
require_relative 'actions/s3/template_url'
require_relative 'actions/s3/location'
require_relative 'actions/s3/upload_template'
require_relative 'actions/s3/bucket_website'

module AwsHelpers

  class S3 < AwsHelpers::Client

    # Utilities for S3 creation and uploading
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    # @return [AwsHelpers::Config] A Config object with options initialized
    def initialize(options = {})
      super(options)
    end

    # Create a new s3 bucket
    # @param s3_bucket_name [String] Name given to the S3 Bucket to create
    # @param acl [String] accepts private, public-read, public-read-write, authenticated-read
    def s3_create(s3_bucket_name, acl = 'private')
      AwsHelpers::Actions::S3::S3Create.new(config, s3_bucket_name, acl).execute
    end

    # Return true if the s3 Bucket exists
    # @param s3_bucket_name [String] Name given to the S3 Bucket
    # @return [Boolean] True if the Bucket exists
    def s3_exists?(s3_bucket_name)
      AwsHelpers::Actions::S3::S3Exists.new(config, s3_bucket_name).execute
    end

    # Get the S3 Bucket URL
    # @param s3_bucket_name [String] Name given to the S3 Bucket
    # @return [String] The S3 Bucket URL
    def s3_url(s3_bucket_name)
      AwsHelpers::Actions::S3::S3TemplateUrl.new(config, s3_bucket_name).execute
    end

    # Get the S3 Bucket location
    # @param s3_bucket_name [String] Name given to the S3 Bucket
    # @return [String] The S3 Bucket AWS Location
    def s3_location(s3_bucket_name)
      AwsHelpers::Actions::S3::S3Location.new(config, s3_bucket_name).execute
    end

    # Create an s3 bucket if it doesn't exist and upload a CloudFormation templates
    # @param stack_name [String] Name given to the stack
    # @param template_json [String] JSON Template as the request body
    # @param s3_bucket_name [String] Name given to the S3 Bucket
    # @param bucket_encrypt [Boolean] Encrypt to S3 content
    # @return [String] The S3 Bucket URL
    def upload_stack_template(stack_name, template_json, s3_bucket_name, bucket_encrypt)
      AwsHelpers::Actions::S3::S3UploadTemplate.new(config, stack_name, template_json, s3_bucket_name, bucket_encrypt).execute
    end

    # Configure website hosting for an S3 bucket
    # @param s3_bucket_name [String] Name given to the S3 Bucket
    # @param website_configuration [Aws::S3::Types::WebsiteConfiguration] Name given to the stack
    # @return [String] The S3 Bucket URL
    def bucket_website(s3_bucket_name, website_configuration = nil)
      AwsHelpers::Actions::S3::S3BucketWebsite.new(config, s3_bucket_name, website_configuration).execute
    end

  end

end


