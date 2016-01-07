require 'mumukit'
require 'yaml'

class TestRunner < Mumukit::Hook
  def run_compilation!(test_definition)
    ['', :passed]
  end
end
