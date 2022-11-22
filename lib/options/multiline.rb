module TextChecker::Multiline
  def self.apply(text)
    text.gsub("\r\n", "\n").chomp
  end
end
