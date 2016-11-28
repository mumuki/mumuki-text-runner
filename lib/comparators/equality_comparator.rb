class EqualityComparator < TransformableComparator
  def compare(source)
    if transform(source) != transform(@expected)
      I18n.t 'equality.failure', actual: source
    end
  end
end
