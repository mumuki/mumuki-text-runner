require_relative './spec_helper'

describe TextChecker do
  let(:checker) { TextChecker.new }
  let(:test) { { source: 'Lorem ipsum dolor sit amet' } }

  describe '#check_equals' do
    let(:result) { checker.check_equal(test, config) }

    context 'when it passes' do
      let(:config) { { expected: 'lorem ipsum dolor sit amet', ignore_case: true } }

      it { expect { result }.not_to raise_error }
    end

    context 'when it fails' do
      let(:config) { { expected: 'Hey!' } }

      it { expect { result }.to raise_error Mumukit::Metatest::Failed }
    end
  end

  describe '#check_contains' do
    let(:result) { checker.check_contain(test, config) }
    let(:test) { { source: 'Lorem ipsum dolor sit amet' } }

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
