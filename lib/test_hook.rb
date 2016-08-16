class TextTestHook < Mumukit::Hook
  def compile(request)
    parse_test(request).merge(source: request[:content].strip)
  end

  def run!(test_definition)
    comparer = comparer_for(test_definition)
    actual = test_definition[:source]

    if comparer.successful_for? actual
      [comparer.success_message(actual), :passed]
    else
      [comparer.error_message(actual), :failed]
    end
  end

  private

  def parse_test(request)
    YAML.load(request[:test]).deep_symbolize_keys
  end

  private

  def comparer_for(test_definition)
    EqualityComparer.new(test_definition, options_for(test_definition))
  end

  def options_for(test_definition)
    options = []
    options << IgnoreWhitespace if test_definition[:ignore_whitespace]
    options << IgnoreCase if test_definition[:ignore_case]
    options
  end
end

