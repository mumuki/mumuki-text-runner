require 'spec_helper'
require 'yaml'

describe TestCompiler do
  before { I18n.locale = :en }

  let(:runner) { TestRunner.new }

  describe '#run_compilation!' do
    let(:output) { runner.run_compilation!(source: source, equal: expected) }
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

      context 'and the default message is used' do
        it { expect(result).to eq '**321** is not the right value.' }
        it { expect(status).to eq :failed }
      end

      context 'and es locale is selected' do
        before { I18n.locale = :es }
        it { expect(result).to eq '**321** no es el valor correcto.' }
      end

      context 'and a message is given' do
        let(:output) { runner.run_compilation!(source: source, expected: expected, error_message: 'Oops, try again') }
        it { expect(result).to eq 'Oops, try again' }
      end
    end
  end
end
