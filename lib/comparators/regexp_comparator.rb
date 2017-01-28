class RegexpComparator < Comparator

  private

  def success?(source)
    !!@expected_regexp.match(source)
  end

  def setup
    @expected_regexp = eval_regexp(@expected)
  end

  def error_message(source)
    I18n.t 'expression.failure', actual: source
  end

  def eval_regexp(expression)
    Regexp.new(expression)
  end
end
