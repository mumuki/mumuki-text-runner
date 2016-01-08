class TestRunner < Mumukit::Hook
  def run_compilation!(test_definition)
    comparer = comparer_for(test_definition)
    actual = test_definition[:source]

    if comparer.successful_for? actual
      [comparer.success_message(actual), :passed]
    else
      [comparer.error_message(actual), :failed]
    end
  end

  private

  def comparer_for(test_definition)
    EqualityComparer.new(test_definition, options_for(test_definition))
  end

  def options_for(test_definition)
    test_definition[:ignore_whitespace] ? [IgnoreWhitespace.new] : []
  end
end

