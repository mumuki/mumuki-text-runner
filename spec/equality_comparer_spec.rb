require_relative './spec_helper'

describe EqualityComparer do

  describe '#satisfies?' do
    let(:result) { EqualityComparer.satisfies?(actual, expected) }
    let(:expected) { 'Lorem ipsum' }

    context 'when they are different' do
      let(:actual) { 'Ipsum lorem' }

      it { expect(result).to be false }
    end

    context 'when they the same' do
      let(:actual) { 'Lorem ipsum' }

      it { expect(result).to be true }
    end

  end

  describe '#locale_error_message' do
    let(:actual) { 'Foo' }

    context 'when language is English' do
      before { I18n.locale = :en }
      let(:error_message) { EqualityComparer.locale_error_message(actual) }

      it { expect(error_message).to eq '**Foo** is not the right value.' }
    end

    context 'when language is Spanish' do
      before { I18n.locale = :es }
      let(:error_message) { EqualityComparer.locale_error_message(actual) }

      it { expect(error_message).to eq '**Foo** no es el valor correcto.' }
    end

  end
end
