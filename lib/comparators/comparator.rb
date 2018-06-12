class Comparator
  def initialize(opts = {})
    @expected = opts[:expected]
    @error_message = opts[:error]
    @config = opts
    setup if respond_to?(:setup, true)
  end

  def compare(source)
    @error_message || error_message(source) unless success?(source)
  end

  private

  def modifiers
    modifiers = []
    modifiers << IgnoreWhitespace if @config[:ignore_whitespace]
    modifiers << IgnoreCase if @config[:ignore_case]
    modifiers
  end

  def transform(source)
    modifiers.inject(source) { |text, modifier| modifier.apply(text) }
  end
end
