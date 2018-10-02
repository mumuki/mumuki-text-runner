require_relative '../spec_helper'

describe RegexpComparator do
  describe '#success?' do
    let(:comparator) { RegexpComparator.new(expected: 'foo|bar*') }
    subject { comparator.success? actual }

    context 'when the regex matches' do
      let(:actual) { 'foobarbar' }

      it { is_expected.to be true }
    end

    context 'when does not match' do
      let(:actual) { 'FooBar' }

      it { is_expected.to be false }
    end
  end

  describe '#error_message' do
    let(:comparator) { RegexpComparator.new(expected: 'zzz') }
    subject { comparator.send(:error_message, 'Hey Arnold!') }

    context 'when language is English' do
      before { I18n.locale = :en }

      it { is_expected.to eq '**Hey Arnold!** does not match the expected expression.' }
    end

    context 'when language is Spanish' do
      before { I18n.locale = :es }

      it { is_expected.to eq '**Hey Arnold!** no coincide con la expresión correcta.' }
    end
  end
end
