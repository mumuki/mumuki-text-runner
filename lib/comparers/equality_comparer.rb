class EqualityComparer
  def initialize(test_definition)
    @expected = test_definition[:expected]
  end

  def successful_for?(actual)
    actual == @expected
  end

  def error_message(actual)
    "#{actual} is not the right value."
  end

  def success_message(actual)
    ''
  end
end
