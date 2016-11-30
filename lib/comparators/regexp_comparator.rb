class RegexpComparator
  include HashedConfiguration

  def initialize(opts)
    options = hash_configuration(opts)
    regexp = eval_regexp(options[:expected])
    raise 'No regexp found' unless regexp.is_a? Regexp
    @expected_regexp = regexp
  end

  def compare(source)
    unless source =~ @expected_regexp
      I18n.t 'expression.failure', actual: source
    end
  end

  private

  def eval_regexp(expression)
    begin
      eval expression
    rescue
      nil
    end
  end
end