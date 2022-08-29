module TextChecker::Multiline
  def self.apply(text)
    text.gsub("\r\n", "\n")
  end
end
