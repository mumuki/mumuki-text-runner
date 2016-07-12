class TextMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'text',
        icon: {type: 'devicon', name: 'code'},
        extension: 'txt',
        test_framework: {
            name: 'text',
            test_extension: 'yml'
        }
    }}
  end
end