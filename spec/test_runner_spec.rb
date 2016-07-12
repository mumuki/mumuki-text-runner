require 'spec_helper'
require 'yaml'

describe TextTestHook do
  before { I18n.locale = :en }

  let(:runner) { TextTestHook.new }

  describe '#run_compilation!' do
    let(:extra) { {} }
    let(:output) { runner.run!({source: source, equal: expected}.merge(extra)) }
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
        let(:output) { runner.run!(source: source, expected: expected, error_message: 'Oops, try again') }
        it { expect(result).to eq 'Oops, try again' }
      end
    end

    context 'ignore whitespace transformation' do
      let(:source) { '2^1 + 2^0' }
      let(:expected) { '2^1+2^0' }
      let(:extra) { { ignore_whitespace: true } }

      it { expect(status).to eq :passed }
    end
  end
end
