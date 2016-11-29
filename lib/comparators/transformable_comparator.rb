class TransformableComparator
  def initialize(opts)
    options = opts.is_a?(Hash) ? opts : { expected: opts }
    @expected = options[:expected]
    parse_modifiers(options)
  end

  private

  def modifiers
    @modifiers
  end

  def parse_modifiers(opts)
    @modifiers = []
    @modifiers << IgnoreWhitespace if opts[:ignore_whitespace]
    @modifiers << IgnoreCase if opts[:ignore_case]
  end

  def transform(source)
    modifiers.inject(source) { |text, modifier| modifier.apply(text) }
  end
end
