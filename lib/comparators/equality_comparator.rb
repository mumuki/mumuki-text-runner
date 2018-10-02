class TextChecker::EqualityComparator < TextChecker::Comparator

  def success?(source)
    source == expected
  end

  private

  def error_message(source)
    I18n.t 'equality.failure', actual: source
  end
end
