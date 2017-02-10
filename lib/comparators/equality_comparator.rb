class EqualityComparator < Comparator

  private

  def success?(source)
    transform(source) == transform(@expected)
  end

  def error_message(source)
    I18n.t 'equality.failure', actual: source
  end
end
