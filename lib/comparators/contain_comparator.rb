class ContainComparator < TransformableComparator
  def compare(source)
    unless transform(source).include? transform(@expected)
      I18n.t 'contain.failure', actual: source
    end
  end
end
