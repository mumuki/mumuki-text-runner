module TextChecker::LenientBlank
  def self.apply(text)
    text.gsub("\t", ' ').squeeze(' ')
  end
end
