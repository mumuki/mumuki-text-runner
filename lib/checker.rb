class TextChecker < Mumukit::Metatest::Checker

  class << self
    def compare(relation_hash)
      raise 'Invalid hash arity' if relation_hash.size != 1
      type = relation_hash.keys.first
      comparator_class = relation_hash.values.first
      define_method "check_#{type}".to_sym do |test, config|
        comparator_class
            .new(config)
            .compare(test[:source])
            .try { |error| fail error }
      end
    end
  end

  compare :equal => EqualityComparator
  compare :contain => ContainComparator


end
