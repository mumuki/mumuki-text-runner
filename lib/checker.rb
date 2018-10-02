class TextChecker < Mumukit::Metatest::Checker
  COMPARATORS = {
    match: RegexpComparator,
    equal: EqualityComparator,
    contain: ContainComparator,
    valid_ip: ValidIpComparator
  }

  def check_assertion(key, input, config, example)
    if key == :keys
      source_hash = YAML.load(input[:source]).with_indifferent_access
      config.each do |subkey, subconfig|
        check_assertions({source: source_hash[subkey]}, subconfig, example)
      end
    else
      COMPARATORS[key]
        .new(config.is_a?(Hash) ? config : {expected: config})
        .compare(input[:source])
        .try { |error| fail error }
    end
  end

  def example_contains_comparator_keys?(example)
    COMPARATORS.keys.any? { |it| example.include?(it) }
  end
end
