require 'spec_helper'
require 'yaml'

describe TestCompiler do
  let(:runner) { TestRunner.new }

  describe '#run_compilation!' do
    let(:output) { runner.run_compilation!(source: source, expected: expected) }
    let(:result) { output[0]}
    let(:status) { output[1] }

    context 'when source string is equal to expected' do
      let(:source) { '123' }
      let(:expected) { '123' }

      it { expect(result).to eq '' }
      it { expect(status).to eq :passed }
    end

    context 'when source string is not equal to expected' do
      let(:source) { '321' }
      let(:expected) { '123' }

      it { expect(result).to eq '321 is not the right value.' }
      it { expect(status).to eq :failed }
    end
  end
end
