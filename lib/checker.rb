class TextChecker < Mumukit::Metatest::Checker
  COMPARATORS = {
    match: RegexpComparator,
    equal: EqualityComparator,
    contain: ContainComparator,
    valid_ip: ValidIpComparator
  }

  def check_assertion(key, input, config, example)
    if key == :keys
      check_keys input, config, example
    else
      check_comparators key, input, config
    end
  end

  def check_comparators(key, input, config)
    COMPARATORS[key]
        .new(config.is_a?(Hash) ? config : {expected: config})
        .compare(input[:source])
        .try { |error| fail error }
  end

  def check_keys(input, config, example)
    source_hash = YAML.load(input[:source]).with_indifferent_access
      config.each do |subkey, subconfig|
        check_assertions({source: source_hash[subkey]}, subconfig, example)
    end
  end
end
