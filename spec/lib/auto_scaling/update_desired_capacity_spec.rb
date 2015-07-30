require 'rspec'
require 'aws_helpers/auto_scaling/client'
require 'aws_helpers/auto_scaling/retrieve_desired_capacity'

describe AwsHelpers::AutoScaling::RetrieveDesiredCapacity do

  let(:auto_scaling_group_name) { 'my_group_name' }
  let(:desired_capacity) { 1 }
  let(:timeout) { 1 }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_auto_scaling_client: double, aws_elastic_load_balancing_client: double) }

  let(:the_updated_capacity) { double(AwsHelpers::AutoScaling::UpdateDesiredCapacity) }

  it 'should create AutoScalingGroup::UpdateDesiredCapacity' do

    allow(AwsHelpers::AutoScaling::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::AutoScaling::UpdateDesiredCapacity).to receive(:new).with(config, auto_scaling_group_name, desired_capacity, timeout).and_return(the_updated_capacity)
    expect(the_updated_capacity).to receive(:execute)
    AwsHelpers::AutoScaling::Client.new(options).update_desired_capacity(auto_scaling_group_name, desired_capacity, timeout)
  end

end