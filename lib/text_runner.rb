require 'mumukit'
require 'yaml'

I18n.load_translations_path File.join(__dir__, 'locales', '*.yml')

Mumukit.runner_name = 'text'
Mumukit.configure do |config|
  config.content_type = 'markdown'
end

require_relative './metadata_hook'
require_relative './test_hook'

require_relative './comparators/comparator'
require_relative './comparators/equality_comparator'
require_relative './comparators/contain_comparator'
require_relative './comparators/regexp_comparator'

require_relative './options/ignore_whitespace'
require_relative './options/ignore_case'

require_relative './checker'
