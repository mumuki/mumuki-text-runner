require_relative '../spec_helper'

describe ContainComparator do
  let(:comparator) { ContainComparator.new(expected: 'Foo bar') }

  describe '#compare' do

    it 'returns nil if contained' do
      expect(comparator.compare('Foo bar baz')).to be_nil
    end

    it 'returns the failure message if not contained' do
      expect(comparator.compare('Hey Arnold!')).to be_an_instance_of String
    end
  end

  describe 'localization' do
    let(:error_message) { comparator.compare('Hey Arnold!') }

    context 'when language is English' do
      before { I18n.locale = :en }

      it { expect(error_message).to eq '**Hey Arnold!** does not contain the right value.' }
    end

    context 'when language is Spanish' do
      before { I18n.locale = :es }

      it { expect(error_message).to eq '**Hey Arnold!** no contiene el valor correcto.' }
    end
  end
end
