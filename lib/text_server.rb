require 'mumukit'
require 'yaml'
require 'i18n'
require 'active_support/all'

Mumukit.configure do |config|
  config.runner_name = 'text-server'
  config.content_type = 'markdown'
end

I18n.load_path += Dir[File.join('.', 'locales', '*.yml')]

require_relative './metadata_publisher'
require_relative './test_compiler'
require_relative './test_runner'

require_relative './comparers/equality_comparer'
require_relative './options/ignore_whitespace'
