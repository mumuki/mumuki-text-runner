require 'mumukit/metatest'

module TextServer
  class Checker < Mumukit::Metatest::Checker

    def check_equal(test, example)
      actual = transform(test[:source], options_for(example))
      expected_value = example.is_a?(String) ? example : example[:expected]
      fail EqualityComparer.locale_error_message(actual) unless
        EqualityComparer.satisfies?(actual, expected_value)
    end

    private
    def transform(text, modifiers)
      modifiers.inject(text) { |text, modifier| modifier.apply(text) }
    end

    def options_for(example)
      if example.is_a? String
        []
      else
        options = []
        options << IgnoreWhitespace if example[:ignore_whitespace]
        options << IgnoreCase if example[:ignore_case]
        options
      end
    end

  end
end
