require 'mumukit/hook'

class TextTestHook < Mumukit::Hook
  def compile(request)
    {source: request[:content].strip, examples: parse_test(request[:test])}
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
    parsed_test = YAML.load(tests)
    if parsed_test.is_a? Array
      parse_multi_scenario_test(parsed_test)
    else
      parse_single_scenario_test(parsed_test)
    end
  end

  def parse_single_scenario_test(parsed_test)
    [{name: 'test',
      postconditions: {equal: {
        expected: parsed_test['equal'],
        ignore_case: parsed_test['ignore_case'].present?,
        ignore_whitespace: parsed_test['ignore_whitespace'].present?}}
     }]
  end

  def parse_multi_scenario_test(parsed_test)
    parsed_test.map { |example| example.deep_symbolize_keys }
  end
end
