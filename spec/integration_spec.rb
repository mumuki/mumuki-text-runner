require 'mumukit/bridge'
require 'active_support/all'

require_relative './spec_helper'

describe 'integration test' do
  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4567') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4567', err: '/dev/null'
    sleep 3
  end
  after(:all) { Process.kill 'TERM', @pid }

  it 'answers a valid hash when submission passes' do
    response = bridge.run_tests!(test: 'equal: test', extra: '', content: 'test', expectations: [])

    expect(response[:status]).to eq(:passed)
  end

  it 'answers a valid hash when submission fails' do
    response = bridge.run_tests!(test: 'equal: test', extra: '', content: 'demo', expectations: [])

    expect(response[:result]).to include 'is not the right value'
    expect(response[:status]).to eq :failed
  end

end
