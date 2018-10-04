require_relative '../spec_helper'

describe TextChecker::ContainComparator do
  let(:comparator) { TextChecker::ContainComparator.new(expected: 'Foo bar') }

  describe '#success?' do
    subject { comparator.success? actual }

    context 'when is contained' do
      let(:actual) { 'Foo bar baz' }

      it { is_expected.to be true }
    end

    context 'when is not contained' do
      let(:actual) { 'Foo quux baz' }

      it { is_expected.to be false }
    end
  end

  describe '#error_message' do
    subject { comparator.send(:error_message, 'Hey Arnold!') }

    context 'when language is English' do
      before { I18n.locale = :en }

      it { is_expected.to eq '**Hey Arnold!** does not contain the right value.' }
    end

    context 'when language is Spanish' do
      before { I18n.locale = :es }

      it { is_expected.to eq '**Hey Arnold!** no contiene el valor correcto.' }
    end
  end
end
