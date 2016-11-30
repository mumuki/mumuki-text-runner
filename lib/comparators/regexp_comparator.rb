class RegexpComparator < HashedConfiguration
  def parse_options(opts)
    regexp = eval_regexp(opts[:expected])
    @expected_regexp = regexp
  end

  def compare(source)
    unless source =~ @expected_regexp
      I18n.t 'expression.failure', actual: source
    end
  end

  private

  def eval_regexp(expression)
    Regexp.new(expression)
  end
end