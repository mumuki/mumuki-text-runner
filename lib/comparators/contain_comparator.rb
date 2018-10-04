class TextChecker::ContainComparator < TextChecker::Comparator

  def success?(source)
    source.include? expected
  end

  private

  def error_message(source)
    I18n.t 'contain.failure', actual: source
  end
end
