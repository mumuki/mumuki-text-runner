require 'rspec'
require 'mumukit/bridge'
require 'simplecov'

def valid_response(test_name)
  {
      response_type: :structured,
      test_results: [{ title: test_name, status: :passed, result: nil }],
      status: :passed,
      feedback: '',
      expectation_results: [],
      result: ''
  }
end

def invalid_response(test_name, result)
  {
      response_type: :structured,
      test_results: [{ title: test_name, status: :failed, result: result }],
      status: :failed,
      feedback: '',
      expectation_results: [],
      result: ''
  }
end

SimpleCov.start

require_relative '../lib/text_runner'
