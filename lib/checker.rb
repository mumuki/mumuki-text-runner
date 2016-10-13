class TextChecker < Mumukit::Metatest::Checker
  def check_equal(test, config)
    EqualityComparator
      .new(config)
      .compare(test[:source])
      .try { |error| fail error }
  end
end
