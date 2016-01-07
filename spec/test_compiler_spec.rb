require 'spec_helper'
require 'yaml'

describe TestCompiler do
  let(:compiler) { TestCompiler.new }

  describe '#create_compilation!' do
    context 'removes trailing whitespaces' do
      let(:output) { compiler.create_compilation!({content: '  content  '}) }
      it { expect(output).to eq 'content' }
    end
  end
end
