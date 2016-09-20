require_relative './spec_helper'

require 'active_support/all'

describe 'integration test' do
  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4567') }
  let(:request) do
    {content: ' Lorem ipsum ',
     test: "- name: 'test1'\n  postconditions:\n    equal: 'Lorem ipsum'",
     extra: ''}
  end

  before(:all) do
    @pid = Process.spawn 'rackup -p 4567', err: '/dev/null'
    sleep 3
  end

  after(:all) { Process.kill 'TERM', @pid }

  xit 'answers a valid hash when submission passes' do
    response = bridge.run_tests!(request)

    expect(response[:status]).to eq(:passed)
  end

  xit 'answers a valid hash when submission fails' do
    response = bridge.run_tests!(request)

    expect(response[:result]).to include 'is not the right value'
    expect(response[:status]).to eq :failed
  end

end
