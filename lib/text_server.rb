require 'mumukit'
require 'yaml'
require 'i18n'
require 'active_support/all'

Mumukit.runner_name = 'text'
Mumukit.configure do |config|
  config.content_type = 'markdown'
end

I18n.load_path += Dir[File.join('.', 'locales', '*.yml')]

require_relative './metadata_hook'
require_relative './test_hook'

require_relative './checker'

require_relative './comparers/equality_comparer'
require_relative './options/ignore_whitespace'
require_relative './options/ignore_case'
