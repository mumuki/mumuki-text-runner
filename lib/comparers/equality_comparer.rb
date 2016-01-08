class EqualityComparer
  def initialize(test_definition)
    @expected = test_definition[:equal]
    @error_message = test_definition[:error_message]
  end

  def successful_for?(actual)
    actual == @expected
  end

  def error_message(actual)
    @error_message || default_error_message(actual)
  end

  def success_message(actual)
    ''
  end

  private

  def default_error_message(actual)
    I18n.t "#{i18n_prefix}.failure", { actual: actual }
  end

  def i18n_prefix
    self.class.name.sub('Comparer', '').underscore
  end
end
