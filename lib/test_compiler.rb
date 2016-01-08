require 'mumukit'
require 'yaml'

class TestCompiler < Mumukit::Hook
  def create_compilation!(request)
    parse_test(request).merge(source: request[:content].strip)
  end

  private

  def parse_test(request)
    YAML.load(request[:test]).deep_symbolize_keys
  end
end
