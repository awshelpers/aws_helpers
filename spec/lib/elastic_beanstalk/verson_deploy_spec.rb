require 'rspec'
require 'aws_helpers/elastic_beanstalk/client'
require 'aws_helpers/elastic_beanstalk/version_deploy'

describe 'AwsHelpers::ElasticBeanStalk::VersionDeploy' do

  let(:application) { 'my_application' }
  let(:environment) { 'my_environment' }
  let(:version) { 'my_version' }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_elastic_beanstalk_client: double, aws_s3_client: double, aws_iam_client: double) }
  let(:version_deploy) { double(AwsHelpers::ElasticBeanstalk::VersionDeploy) }

  it '#deploy' do


    allow(AwsHelpers::ElasticBeanstalk::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::ElasticBeanstalk::VersionDeploy).to receive(:new).with(config, application, environment, version).and_return(version_deploy)
    expect(version_deploy).to receive(:execute)
    AwsHelpers::ElasticBeanstalk::Client.new(options).deploy(application, environment, version)

  end
end