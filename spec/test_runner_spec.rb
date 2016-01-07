require 'spec_helper'
require 'yaml'

describe TestCompiler do
  let(:runner) { TestRunner.new }

  describe '#run_compilation!' do
    context 'removes trailing whitespaces' do
      let(:output) { runner.run_compilation!({}) }
      let(:result) { output[0]}
      let(:status) { output[1] }

      it { expect(result).to eq '' }
      it { expect(status).to eq :passed }
    end
  end
end
