class EqualityComparator
  def initialize(opts)
    parse_options(opts.is_a?(Hash) ? opts : {expected: opts})
  end

  def compare(source)
    if transform(source) != transform(@expected)
      I18n.t 'equality.failure', actual: source
    end
  end

  private

  def transform(source)
    @modifiers.inject(source) { |text, modifier| modifier.apply(text) }
  end

  def parse_options(opts)
    @expected = opts[:expected]
    @modifiers = []
    @modifiers << IgnoreWhitespace if opts[:ignore_whitespace]
    @modifiers << IgnoreCase if opts[:ignore_case]
  end
end
