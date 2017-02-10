class ContainComparator < Comparator

  private

  def success?(source)
    transform(source).include? transform(@expected)
  end

  def error_message(source)
    I18n.t 'contain.failure', actual: source
  end
end
