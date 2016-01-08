require 'spec_helper'

describe TestCompiler do
  let(:compiler) { TestCompiler.new }
  let(:output) { compiler.create_compilation!({content: content, test: test}) }
  let(:content) { 'content' }
  let(:test) { 'equals: test' }

  describe '#create_compilation!' do
    context 'removes trailing whitespaces from source' do
      let(:content) { '  content  ' }
      it { expect(output[:source]).to eq 'content' }
    end

    context 'deserializes YAML test' do
      let(:test) { "equals: '100'" }
      it { expect(output[:equals]).to eq '100' }
    end
  end
end
