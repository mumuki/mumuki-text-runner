module IgnoreWhitespace
  class << self
    def apply(text)
      text.delete(' ')
    end
  end
end
