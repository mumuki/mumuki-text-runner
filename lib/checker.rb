class TextChecker < Mumukit::Metatest::Checker
  require_relative './comparators/comparator'
  require_relative './comparators/equality_comparator'
  require_relative './comparators/contain_comparator'
  require_relative './comparators/regexp_comparator'
  require_relative './comparators/valid_ip_comparator'

  require_relative './options/lenient_blank'
  require_relative './options/ignore_case'
  require_relative './options/ignore_whitespace'
  require_relative './options/multiline'

  COMPARATORS = {
    match: TextChecker::RegexpComparator,
    equal: TextChecker::EqualityComparator,
    contain: TextChecker::ContainComparator,
    valid_ip: TextChecker::ValidIpComparator
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
