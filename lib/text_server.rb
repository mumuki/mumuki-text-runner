require 'mumukit'
require 'active_support/all'

Mumukit.configure do |config|
  config.runner_name = 'text-server'
  config.content_type = 'markdown'
end

require_relative './metadata_publisher'
require_relative './test_compiler'
require_relative './test_runner'
