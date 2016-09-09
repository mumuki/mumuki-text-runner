require_relative './spec_helper'

describe TextTestHook do
  let(:compiler) { TextTestHook.new }
  let(:output) { compiler.compile({content: content, test: test}) }
  let(:content) { 'content' }
  let(:test) { 'equals: test' }

  describe '#create_compilation!' do
    context 'removes trailing whitespaces from source' do
      let(:content) { '  content  ' }
      it {
        expect(output[:source]).to eq 'content'
      }
    end

    context 'deserializes YAML test' do
      let(:test) { "equal: '100'" }
      it {
        expect(output[:equal]).to eq '100'
      }
    end
  end
end
