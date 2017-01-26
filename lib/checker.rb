class TextChecker < Mumukit::Metatest::Checker
  def self.compare(relation_hash)
    raise 'Invalid hash arity' if relation_hash.size != 1
    type = relation_hash.keys.first
    comparator_class = relation_hash.values.first
    define_method "check_#{type}".to_sym do |test, config|
      comparator_class
        .new(config.is_a?(Hash) ? config : {expected: config})
        .compare(test[:source])
        .try { |error| fail error }
    end
  end

  compare :match => RegexpComparator
  compare :equal => EqualityComparator
  compare :contain => ContainComparator
end
