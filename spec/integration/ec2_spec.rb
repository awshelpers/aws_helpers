require 'aws_helpers/ec2'

describe AwsHelpers::EC2 do

  random_string = ('a'..'z').to_a.shuffle[0, 8].join
  instance_id = nil

  let(:image_id) { 'ami-69631053' }
  let(:min_count) { 1 }
  let(:max_count) { 1 }
  let(:monitoring) { true }

  let(:app_name) { "ec2-integration-test-#{random_string}" }
  let(:options) { {app_name: app_name} }

  let(:tags) { [
      {values: app_name},
  ] }

  before(:each) do
    instance_id = AwsHelpers::EC2.new.instance_create(image_id, min_count, max_count, monitoring, options)
  end

  after(:each) do
    AwsHelpers::EC2.new.instance_terminate(instance_id) if instance_id
  end

  it 'should return the instance_id of the instance created' do
    response = AwsHelpers::EC2.new.instance_find_by_tags(tags)
    expect(response.reservations.first.instances.first.instance_id).to eq(instance_id)
  end

end
