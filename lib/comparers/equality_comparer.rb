class EqualityComparer
  def initialize(config)
    opts = config
    opts = { expected: config } unless config.is_a? Hash
    @expected = opts[:expected]
    parse_options(opts)
  end

  def satisfies?(source)
    @actual = transform(source)
    @actual == transform(@expected)
  end

  def locale_error_message
    I18n.t 'equality.failure', actual: @actual
  end

  private

  def transform(source)
    @modifiers.inject(source) { |text, modifier| modifier.apply(text) }
  end

  def parse_options(config)
    @modifiers = []
    @modifiers << IgnoreWhitespace if config[:ignore_whitespace]
    @modifiers << IgnoreCase if config[:ignore_case]
  end
end
