require_relative '../spec_helper'

describe TransformableComparator do
  describe '#initialize' do
    let(:modifiers) { comparator.send :modifiers }
    let(:expected_value) { comparator.send :instance_variable_get, :@expected }

    context 'when given a string' do
      let(:comparator) { TransformableComparator.new('foo bar') }

      it { expect(modifiers).to be_empty }
      it { expect(expected_value).to eq 'foo bar' }
    end

    context 'when given a hash' do
      let(:comparator) { TransformableComparator.new(expected: 'foo bar', ignore_case: true, ignore_whitespace: false) }

      it { expect(modifiers).to contain_exactly IgnoreCase }
      it { expect(expected_value).to eq 'foo bar' }
    end
  end
end