require_relative './spec_helper'

describe EqualityComparator do

  describe '#initialize' do
    let(:modifiers) { comparator.send :instance_variable_get, :@modifiers }
    let(:expected_value) { comparator.send :instance_variable_get, :@expected }

    context 'when given a string' do
      let(:comparator) { EqualityComparator.new('foo') }

      it { expect(modifiers).to be_empty }
      it { expect(expected_value).to eq 'foo' }
    end

    context 'when given a hash' do
      let(:comparator) { EqualityComparator.new(expected: 'foo', ignore_case: true) }

      it { expect(modifiers).to contain_exactly IgnoreCase }
      it { expect(expected_value).to eq 'foo' }
    end
  end

  describe 'test' do
    context 'without modifiers' do
      let(:comparator) { EqualityComparator.new('Foo') }

      it 'returns true if they are the same' do
        expect(comparator.compare('Foo')).to be_falsey
      end

      it 'returns false if they are different' do
        expect(comparator.compare('Hey Arnold!')).to be_truthy
      end
    end

    context 'with modifiers' do
      let(:comparator) { EqualityComparator.new(expected: 'foo', ignore_case: true) }

      it 'returns true if they are the same' do
        expect(comparator.compare('Foo')).to be_falsey
      end

      it 'returns false if they are different' do
        expect(comparator.compare('Hey Arnold!')).to be_truthy
      end
    end
  end

  describe 'localization' do
    let(:comparator) { EqualityComparator.new('Foo') }
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
