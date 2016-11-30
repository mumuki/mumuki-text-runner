module HashedConfiguration
  def hash_configuration(opts)
    opts.is_a?(Hash) ? opts : { expected: opts }
  end
end