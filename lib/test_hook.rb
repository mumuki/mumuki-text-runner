require 'mumukit/hook'

class TextTestHook < Mumukit::Hook
  def compile(request)
    { source: request[:content].strip, examples: parse_test(request[:test]) }
  end

  def run!(test_definition)
    metatest.test(test_definition, test_definition[:examples])
  end

  private

  def metatest
    Mumukit::Metatest::Framework.new(checker: TextChecker.new,
                                     runner: Mumukit::Metatest::IdentityRunner.new)
  end

  def parse_test(tests)
    YAML.load(tests).map { |example| example.deep_symbolize_keys }
  end
end
