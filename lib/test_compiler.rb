require 'mumukit'

class TestCompiler < Mumukit::Hook
  def create_compilation!(request)
    request[:content].strip
  end
end
