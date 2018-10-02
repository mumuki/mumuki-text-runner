class TextChecker < Mumukit::Metatest::Checker
  COMPARATORS = {
    match: RegexpComparator,
    equal: EqualityComparator,
    contain: ContainComparator,
    valid_ip: ValidIpComparator
  }

  def check_assertion(key, result, config, _example)
    COMPARATORS[key]
      .new(config.is_a?(Hash) ? config : {expected: config})
      .compare(result[:source])
      .try { |error| fail error }
  end
end
