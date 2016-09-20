require 'mumukit/hook'

class TextTestHook < Mumukit::Hook
  def compile(request)
    parse_test(request[:test]).merge(source: request[:content].strip)
  end

  def run!(test_definition)
    metatest.test(test_definition,
                  test_definition[:examples])
  end

  private
  def metatest
    Mumukit::Metatest::Framework.new(checker: TextServer::Checker.new,
                                     runner: Mumukit::Metatest::IdentityRunner.new)
  end

  def parse_test(request)
    {examples: YAML.load(request).map { |example| example.deep_symbolize_keys }}
  end

end
