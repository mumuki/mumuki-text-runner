class Key
  def initialize(key)
    @key = key
  end

  def apply(text)
    yaml = YAML.load(text)
    yaml.is_a?(Hash) ? yaml.with_indifferent_access[@key] : yaml
  end
end
