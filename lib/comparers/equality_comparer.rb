class EqualityComparer
  def initialize(test_definition)
    @expected = test_definition[:expected]
    @error_message = test_definition[:error_message]
  end

  def successful_for?(actual)
    actual == @expected
  end

  def error_message(actual)
    @error_message || default_error_message(actual)
  end

  def default_error_message(actual)
    I18n.t 'equality.failure', { actual: actual }
  end

  def success_message(actual)
    ''
  end
end
