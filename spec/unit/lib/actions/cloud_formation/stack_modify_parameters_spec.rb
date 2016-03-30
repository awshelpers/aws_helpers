require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_information'
require 'aws_helpers/actions/cloud_formation/stack_parameter_update_builder'
require 'aws_helpers/actions/cloud_formation/stack_modify_parameters'
require 'aws_helpers/actions/cloud_formation/poll_stack_status'

include Aws::CloudFormation::Types
include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackModifyParameters do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }

  let(:max_attempts) { 1 }
  let(:delay) { 1 }

  let(:stack_name) { 'my_stack_name' }
  let(:stack_modify_parameters_polling) { { max_attempts: max_attempts, delay: delay } }
  let(:stack_modify_parameters_options) { { stack_name: stack_name, stdout: stdout, max_attempts: max_attempts, delay: delay } }

  let(:options) { { stdout: stdout, polling: stack_modify_parameters_polling } }

  let(:stack_information) { instance_double(StackInformation) }
  let(:stack_parameter_update_builder) { instance_double(StackParameterUpdateBuilder) }
  let(:poll_stack_update) { instance_double(PollStackStatus) }

  let(:parameters_to_update) do
    [
      { parameter_key: 'param_key_1', parameter_value: 'param_value_1' },
      { parameter_key: 'param_key_2', parameter_value: 'new_param_value_2' }
    ]
  end

  let(:existing_parameters) do
    [
      Parameter.new(parameter_key: 'param_key_1', parameter_value: 'param_value_1', use_previous_value: true),
      Parameter.new(parameter_key: 'param_key_2', parameter_value: 'param_value_1', use_previous_value: true)
    ]
  end

  let(:updated_parameters) do
    [
      { parameter_key: 'param_key_1', use_previous_value: true },
      { parameter_key: 'param_key_2', parameter_value: 'new_param_value_2' }
    ]
  end

  let(:stack_existing) do
    [
      Stack.new(stack_name: stack_name, parameters: existing_parameters, capabilities: ['CAPABILITY_IAM'])
    ]
  end

  let(:stack_updated) do
    { stack_name: stack_name, use_previous_template: true, parameters: updated_parameters, capabilities: ['CAPABILITY_IAM'] }
  end

  let(:stack_events) { [instance_double(StackEvent, resource_status: 'status')] }
  let(:stack_response) { instance_double(DescribeStacksOutput, stacks: stack_existing) }
  let(:stack_events_response) { instance_double(DescribeStackEventsOutput, stack_events: stack_events, next_token: nil) }

  let(:max_attempts) { 10 }
  let(:delay) { 5 }

  before(:each) do
    allow(stdout).to receive(:puts).with(anything)
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(stack_response)
    allow(cloudformation_client).to receive(:describe_stack_events).with(stack_name: stack_name, next_token: nil).and_return(stack_events_response)
    allow(cloudformation_client).to receive(:update_stack).with(stack_updated)
    allow(PollStackStatus).to receive(:new).with(config, stack_modify_parameters_options).and_return(poll_stack_update)
    allow(poll_stack_update).to receive(:execute)
  end

  after(:each) do
    StackModifyParameters.new(config, stack_name, parameters_to_update, options).execute
  end

  it 'should call describe stack to get the current stack parameters' do
    expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(stack_response)
  end

  it 'should build the request for the stack update' do
    expect(StackParameterUpdateBuilder.new(stack_name, stack_existing[0], parameters_to_update).execute).to eq(stack_updated)
  end

  it 'should call the update_stack method to start the stack update process' do
    expect(cloudformation_client).to receive(:update_stack).with(stack_updated)
  end

  it 'should call update_stack using the request generated' do
    expect(poll_stack_update).to receive(:execute)
  end
end
