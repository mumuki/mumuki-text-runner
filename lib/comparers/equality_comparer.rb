class EqualityComparer
  def initialize(test_definition, options)
    @options = options
    @error_message = test_definition[:error_message]
    @expected = test_definition[:equal]
  end

  def successful_for?(actual)
    transform(actual) == transform(@expected)
  end

  def error_message(actual)
    @error_message || default_error_message(actual)
  end

  def success_message(actual)
    ''
  end

  def transform(text)
    @options.reduce(text) { |acum, elem| elem.apply acum }
  end

  private

  def default_error_message(actual)
    I18n.t "#{i18n_prefix}.failure", { actual: actual }
  end

  def i18n_prefix
    self.class.name.sub('Comparer', '').underscore
  end
end
