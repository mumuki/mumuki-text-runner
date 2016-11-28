require_relative './spec_helper'

describe ContainComparator do

  describe '#initialize' do
    let(:modifiers) { comparator.send :modifiers }
    let(:expected_value) { comparator.send :instance_variable_get, :@expected }

    context 'when given a string' do
      let(:comparator) { ContainComparator.new('foo bar') }

      it { expect(modifiers).to be_empty }
      it { expect(expected_value).to eq 'foo bar' }
    end

    context 'when given a hash' do
      let(:comparator) { ContainComparator.new(expected: 'foo bar', ignore_case: true, ignore_whitespace: false) }

      it { expect(modifiers).to contain_exactly IgnoreCase }
      it { expect(expected_value).to eq 'foo bar' }
    end
  end

  describe '#compare' do
    context 'without modifiers' do
      let(:comparator) { ContainComparator.new('Foo bar') }

      it 'returns nil if they are the same' do
        expect(comparator.compare('Foo bar baz')).to be_nil
      end

      it 'returns the failure message if they are different' do
        expect(comparator.compare('Hey Arnold!')).to be_truthy
      end
    end

    context 'with modifiers' do
      let(:comparator) { ContainComparator.new(expected: 'foo Bar ', ignore_case: true, ignore_whitespace: true) }

      it 'returns nil if they are the same' do
        expect(comparator.compare('QUUX FOO BAR BAZ')).to be_nil
      end

      it 'returns the failure message if they are different' do
        expect(comparator.compare('Hey Arnold!')).to be_truthy
      end
    end
  end

  describe 'localization' do
    let(:comparator) { ContainComparator.new('Foo Bar') }
    let(:error_message) { comparator.compare('Bar Foo') }

    context 'when language is English' do
      before { I18n.locale = :en }

      it { expect(error_message).to eq '**Bar Foo** does not contains the right value.' }
    end

    context 'when language is Spanish' do
      before { I18n.locale = :es }

      it { expect(error_message).to eq '**Bar Foo** no contiene el valor correcto.' }
    end
  end
end
