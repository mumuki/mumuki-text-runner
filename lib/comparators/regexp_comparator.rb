class RegexpComparator
  def initialize(opts)
    regexp = eval_regexp(opts[:expected])
    @expected_regexp = regexp
    @error = opts[:error]
  end

  def compare(source)
    unless source =~ @expected_regexp
      error_message(source)
    end
  end

  private

  def error_message(source)
    @error || (I18n.t 'expression.failure', actual: source)
  end

  def eval_regexp(expression)
    Regexp.new(expression)
  end
end
