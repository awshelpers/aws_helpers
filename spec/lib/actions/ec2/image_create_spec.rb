require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/image_create'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe ImageCreate do

  let(:name) { 'ec2_name' }
  let(:instance_id) { 'ec2_id' }
  let(:additional_tags) { %w('tag1', 'tag2') }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_ec2_client: double) }
  let(:image_create) { double(ImageCreate) }

  it '#image_create without additional tags' do
    allow(Config).to receive(:new).with(options).and_return(config)
    allow(ImageCreate).to receive(:new).with(config, name, instance_id, []).and_return(image_create)
    expect(image_create).to receive(:execute)
    EC2.new(options).image_create(name: name, instance_id: instance_id)
  end

  it '#image_create with additional tags' do
    allow(Config).to receive(:new).with(options).and_return(config)
    allow(ImageCreate).to receive(:new).with(config, name, instance_id, additional_tags).and_return(image_create)
    expect(image_create).to receive(:execute)
    EC2.new(options).image_create(name: name, instance_id: instance_id, additional_tags: additional_tags)
  end

end