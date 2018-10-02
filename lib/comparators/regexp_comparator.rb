class RegexpComparator < Comparator

  private

  def success?(source)
    !!regexp.match(source)
  end

  def regexp
    @regexp ||= Regexp.new @expected
  end

  def error_message(source)
    I18n.t 'expression.failure', actual: source
  end
end
