class ContainComparator < Comparator
  def success?(source)
    transform(source).include? transform(@expected)
  end

  private

  def error_message(source)
    I18n.t 'contain.failure', actual: source
  end
end
