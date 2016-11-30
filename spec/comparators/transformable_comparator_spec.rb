require_relative '../spec_helper'

describe TransformableComparator do
  describe '#transform' do
    let(:comparator) { TransformableComparator.new(expected: 'foo bar', ignore_case: true, ignore_whitespace: true) }

    it 'folds each modifier on the given text' do
      expect(comparator.send :transform, 'Hi There!').to eq 'hithere!'
    end
  end
end
