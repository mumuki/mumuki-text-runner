require_relative '../spec_helper'

describe RegexpComparator do
  describe '#initialize' do
    context 'when expected value is not a string' do
      it { expect { RegexpComparator.new(expected: 1) }.to raise_exception TypeError }
      it { expect { RegexpComparator.new(expected: []) }.to raise_exception TypeError }
    end
  end

  describe '#compare' do
    context 'when matches returns nil' do
      subject { RegexpComparator.new(expected: 'Foo').compare('Foo') }

      it { is_expected.to be_nil }
    end

    context 'when does not match' do
      let(:opts) { {expected: 'Foo'} }
      subject { RegexpComparator.new(opts).compare('Bar') }

      context 'returns default message' do
        before { I18n.locale = :en }

        it { is_expected.to eq('**Bar** does not match the expected expression.') }
      end

      context 'given custom message' do
        let(:opts) { {expected: 'Foo', error: 'Custom error'} }

        it { is_expected.to eq('Custom error') }
      end
    end
  end

  describe 'localization' do
    subject { RegexpComparator.new(expected: 'John').compare('Andrew') }

    context 'when language is English' do
      before { I18n.locale = :en }

      it { is_expected.to eq '**Andrew** does not match the expected expression.' }
    end

    context 'when language is Spanish' do
      before { I18n.locale = :es }

      it { is_expected.to eq '**Andrew** no coincide con la expresión correcta.' }
    end
  end
end
