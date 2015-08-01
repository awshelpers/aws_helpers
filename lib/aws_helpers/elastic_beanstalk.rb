require 'aws-sdk-core'
require_relative 'common/client'
require_relative 'config'
require_relative 'elastic_beanstalk/version_deploy'
require_relative 'elastic_beanstalk/version_upload'

module AwsHelpers

  class ElasticBeanstalk < AwsHelpers::Common::Client

    # Utilities for ElasticBeanstalk deployment
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    def initialize(options = {})
      super(AwsHelpers::Config.new(options))
    end

    # @param application [String] Name given to the AWS ElasticBeanstalk application
    # @param environment [String] Environment target of the app (dev, test - etc)
    # @param version [String] Version of the deployed application
    def deploy(application:, environment:, version:)
      ElasticBeanstalkActions::VersionDeploy.new(config, application, environment, version).execute
    end

    # @param upload_parameters [String] Upload version parameters

    def upload(upload_parameters:)
      ElasticBeanstalkActions::VersionUpload.new(config, upload_parameters).execute
    end

  end

end