require_relative '../spec_helper'

describe EqualityComparator do
  let(:comparator) { EqualityComparator.new('Foo Bar') }

  describe '#compare' do

    it 'returns nil if equal' do
      expect(comparator.compare('Foo Bar')).to be_nil
    end

    it 'returns the failure message if different' do
      expect(comparator.compare('Hey Arnold!')).to be_an_instance_of String
    end
  end

  describe 'localization' do
    let(:error_message) { comparator.compare('Andrew') }

    context 'when language is English' do
      before { I18n.locale = :en }

      it { expect(error_message).to eq '**Andrew** is not the right value.' }
    end

    context 'when language is Spanish' do
      before { I18n.locale = :es }

      it { expect(error_message).to eq '**Andrew** no es el valor correcto.' }
    end
  end
end
