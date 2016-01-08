require 'spec_helper'

describe TestCompiler do
  let(:compiler) { TestCompiler.new }

  describe '#create_compilation!' do
    context 'removes trailing whitespaces from source' do
      let(:output) { compiler.create_compilation!({content: '  content  '}) }
      it { expect(output[:source]).to eq 'content' }
    end
  end
end
