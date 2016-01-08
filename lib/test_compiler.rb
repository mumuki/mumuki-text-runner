require 'mumukit'
require 'yaml'

class TestCompiler < Mumukit::Hook
  def create_compilation!(request)
    { source: request[:content].strip }
  end
end
