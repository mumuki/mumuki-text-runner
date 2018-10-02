class Comparator
  def initialize(config = {})
    @config = config
  end

  def compare(source)
    @config[:error] || error_message(source) unless success?(transform(source))
  end

  def expected
    transform @config[:expected]
  end

  private

  def modifiers
    modifiers = []
    modifiers << IgnoreWhitespace if @config[:ignore_whitespace]
    modifiers << IgnoreCase if @config[:ignore_case]
    modifiers << Key.new(@config[:key]) if @config[:key]
    modifiers
  end

  def transform(source)
    modifiers.inject(source) { |text, modifier| modifier.apply(text) }
  end
end
