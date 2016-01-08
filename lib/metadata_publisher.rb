class MetadataPublisher < Mumukit::Hook
  def metadata
    {language: {
      name: 'text',
      icon: {type: 'devicon', name: 'code'},
      extension: 'txt'
    }}
  end
end
