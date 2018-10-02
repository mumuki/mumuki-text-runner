class TextChecker < Mumukit::Metatest::Checker
  COMPARATORS = {
    match: RegexpComparator,
    equal: EqualityComparator,
    contain: ContainComparator,
    valid_ip: ValidIpComparator
  }

  def check_assertion(key, result, config, example)
    if key == :keys
      source_hash = YAML.load(result[:source]).with_indifferent_access
      config.each do |subkey, subconfig|
        subconfig.each do |assertion_name, assertion_config|
          check_assertion assertion_name, {source: source_hash[subkey]}, assertion_config, example
        end
      end
    else
      COMPARATORS[key]
        .new(config.is_a?(Hash) ? config : {expected: config})
        .compare(result[:source])
        .try { |error| fail error }
    end
  end
end
