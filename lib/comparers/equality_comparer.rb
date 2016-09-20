class EqualityComparer
  class << self

    def satisfies?(actual, expected)
      actual == expected
    end

    def locale_error_message(actual)
      I18n.t 'equality.failure', {actual: actual}
    end

  end
end

