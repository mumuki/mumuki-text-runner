class RegexComparator
  def initialize(opts)
    regexp = eval opts[:expected]
    raise 'No regex found' unless regexp.is_a? Regexp
    @expected_regexp = regexp
  end

  def compare(source)
    if source
  end
end