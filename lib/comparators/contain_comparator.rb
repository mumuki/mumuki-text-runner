class TextChecker::ContainComparator < TextChecker::Comparator

  def success?(source)
    source.include? expected.to_s
  end

  private

  def error_message(source)
    I18n.t 'contain.failure', actual: source
  end
end
