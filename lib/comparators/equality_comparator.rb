class EqualityComparator < Comparator
  def success?(source)
    transform(source) == transform(@expected)
  end

  private

  def error_message(source)
    I18n.t 'equality.failure', actual: source
  end

end
