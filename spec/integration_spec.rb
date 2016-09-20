require_relative './spec_helper'

require 'active_support/all'

describe 'integration test' do
  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4567') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4567', err: '/dev/null'
    sleep 3
  end

  after(:all) { Process.kill 'TERM', @pid }

  it 'answers a valid hash when submission fails' do
    response = bridge.run_tests!(content: ' Lorem ipsum ',
                                 test: "- name: 'test1'\n  postconditions:\n    equal: 'Lorem ipsum'",
                                 extra: '')

    expect(response).to eq response_type: :structured,
                           test_results: [{title: 'test1', status: :passed, result: nil}],
                           status:  :passed,
                           feedback: '',
                           expectation_results: [],
                           result: ''
  end

  it 'answers a valid hash when submission passes' do
    response = bridge.run_tests!(content: ' Dolor amet ',
                                 test: "- name: 'test2'\n  postconditions:\n    equal: 'Lorem ipsum'",
                                 extra: '')

    expect(response).to eq response_type: :structured,
                           test_results: [{title: 'test2', status: :failed, result: '**Dolor amet** is not the right value.'}],
                           status:  :failed,
                           feedback: '',
                           expectation_results: [],
                           result: ''
  end

end
