class RegexpComparator < Comparator

  def success?(source)
    !!Regexp.new(expected).match(source)
  end

  private


  def error_message(source)
    I18n.t 'expression.failure', actual: source
  end
end
