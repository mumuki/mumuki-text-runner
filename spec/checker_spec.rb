require_relative './spec_helper'

describe TextChecker do

  describe '.compare' do
    let(:checker) { TextChecker }

    context 'when hash arity is not one it fails' do

      it { expect { checker.compare({}) }.to raise_exception 'Invalid hash arity' }
      it { expect { checker.compare(a: 1, b: 2) }.to raise_exception 'Invalid hash arity' }
    end

    it 'defines an instance method' do
      checker.compare(foo: 1)
      expect(checker.new.respond_to? :check_foo).to be true
    end
  end

  context 'checks' do
    let(:test) { { source: 'Lorem ipsum dolor sit amet' } }

    describe '#check_equals' do
      let(:checker) do
        TextChecker.compare(equal: EqualityComparator)
        TextChecker.new
      end
      let(:result) { checker.check_equal(test, config) }

      context 'when it passes' do
        let(:config) { { expected: 'Lorem ipsum DOLOR SIT amet', ignore_case: true } }

        it { expect { result }.not_to raise_error }
      end

      context 'when it fails' do
        let(:config) { { expected: 'Hey!' } }

        it { expect { result }.to raise_error Mumukit::Metatest::Failed }
      end
    end

    describe '#check_contains' do
      let(:checker) do
        TextChecker.compare(contain: ContainComparator)
        TextChecker.new
      end
      let(:result) { checker.check_contain(test, config) }


      context 'when it passes' do
        let(:config) { { expected: 'IPSUM dolOr', ignore_case: true } }

        it { expect { result }.not_to raise_error }
      end

      context 'when it fails' do
        let(:config) { { expected: 'Hey!' } }

        it { expect { result }.to raise_error Mumukit::Metatest::Failed }
      end
    end
  end
end
