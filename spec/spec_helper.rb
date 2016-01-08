require 'mumukit'
require 'i18n'
require 'codeclimate-test-reporter'

require_relative '../lib/text_server'

I18n.load_path += Dir[File.join('.', 'locales', '*.yml')]
CodeClimate::TestReporter.start
