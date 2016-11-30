require_relative '../spec_helper'

describe RegexpComparator do
  let(:comparator) { RegexpComparator.new('Foo Bar') }

  describe '#compare' do

    it 'fails if expected value is not a string' do
      expect { RegexpComparator.new(1) }.to raise_exception TypeError
      expect { RegexpComparator.new([]) }.to raise_exception TypeError
    end

    it 'ignores options' do
      comparator = RegexpComparator.new(expected: 'Foo Bar', ignore_case: true)
      expect(comparator.compare('foo bar')).to be_an_instance_of String
    end

    it 'returns nil if matches' do
      expect(comparator.compare('Foo Bar')).to be_nil
    end

    it 'returns the failure message if does not match' do
      expect(comparator.compare('Foo bar!')).to be_an_instance_of String
    end
  end

  describe 'localization' do
    let(:error_message) { comparator.compare('Andrew') }

    context 'when language is English' do
      before { I18n.locale = :en }

      it { expect(error_message).to eq '**Andrew** does not match the expected expression.' }
    end

    context 'when language is Spanish' do
      before { I18n.locale = :es }

      it { expect(error_message).to eq '**Andrew** no coincide con la expresión correcta.' }
    end
  end
end
