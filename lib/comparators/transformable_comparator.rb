class TransformableComparator < HashedConfiguration

  private

  def parse_options(opts)
    @expected = opts[:expected]
    parse_modifiers(opts)
  end

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
