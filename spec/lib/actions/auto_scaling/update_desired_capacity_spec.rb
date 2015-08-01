require 'aws_helpers/auto_scaling'
require 'aws_helpers/actions/auto_scaling/retrieve_desired_capacity'

include AwsHelpers
include AwsHelpers::Actions::AutoScaling

describe RetrieveDesiredCapacity do

  let(:auto_scaling_group_name) { 'my_group_name' }
  let(:desired_capacity) { 1 }
  let(:timeout) { 1 }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(aws_auto_scaling_client: double, aws_elastic_load_balancing_client: double) }
  let(:the_updated_capacity) { double(UpdateDesiredCapacity) }

  it 'should create AutoScalingGroup::UpdateDesiredCapacity' do
    allow(Config).to receive(:new).with(options).and_return(config)
    allow(UpdateDesiredCapacity).to receive(:new).with(config, auto_scaling_group_name, desired_capacity, timeout).and_return(the_updated_capacity)
    expect(the_updated_capacity).to receive(:execute)
    AutoScaling.new(options).update_desired_capacity(auto_scaling_group_name: auto_scaling_group_name, desired_capacity: desired_capacity, timeout: timeout)
  end

end