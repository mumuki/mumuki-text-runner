module TextChecker::IgnoreWhitespace
  def self.apply(text)
    text.delete(' ')
  end
end
