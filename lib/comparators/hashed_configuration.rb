class HashedConfiguration
  def initialize(opts)
    parse_options(opts.is_a?(Hash) ? opts : { expected: opts })
  end
end