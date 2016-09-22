module TextServer
  class Checker < Mumukit::Metatest::Checker
    def check_equal(test, config)
      actual = test[:source]
      comparer = EqualityComparer.new(config)
      fail comparer.locale_error_message unless comparer.satisfies?(actual)
    end
  end
end
