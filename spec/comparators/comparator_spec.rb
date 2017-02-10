require_relative '../spec_helper'

describe Comparator do
  describe '#transform' do
    let(:comparator) { Comparator.new(expected: 'foo bar', ignore_case: true, ignore_whitespace: true) }

    it 'folds each modifier on the given text' do
      expect(comparator.send :transform, 'Hi There!').to eq 'hithere!'
    end
  end

  describe '#compare' do
    let(:comparator) do
      comparator_class = Class.new(Comparator) do
        def success?(source)
          source == @expected
        end

        def error_message(_source)
          'Defined error'
        end
      end
      comparator_class
    end

    context 'when successful' do
      let(:comparation_result) { comparator.new(expected: 'Foo').compare('Foo') }

      it 'returns nil' do
        expect(comparation_result).to be_nil
      end
    end

    context 'when unsuccessful' do
      let(:comparation_result) { comparator.new(params).compare('Bar') }

      context 'given custom error message' do
        let(:params) { {expected: 'Foo', error: 'Custom error'} }

        it 'returns the custom error' do
          expect(comparation_result).to eq 'Custom error'
        end
      end

      context 'without custom error message' do
        let(:params) { {expected: 'Foo'} }

        it 'returns defined error message' do
          expect(comparation_result).to eq 'Defined error'
        end
      end
    end
  end
end
