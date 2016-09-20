require_relative './spec_helper'

describe TextServer::Checker do
  let(:checker) { TextServer::Checker.new }

  describe '#check_equals' do
    let(:result) { checker.check_equal(test, example) }
    let(:test) { {source: 'Lorem ipsum dolor sit amet'} }

    context 'when its a hash' do
      let(:example) { {expected: 'lorem ipsum dolor sit amet', ignore_case: true} }

      it 'doesnt fail if they are the same' do
        expect { result }.not_to raise_error
      end
    end

    context 'when its a string' do
      let(:example) { 'Lorem ipsum dolor sit amet' }

      it 'doesnt fail if they are the same' do
        expect { result }.not_to raise_error
      end
    end

    context 'when they are not the same' do
      let(:example) { {expected: 'Hey!'} }

      it 'fails' do
        expect { result }.to raise_error Mumukit::Metatest::Failed
      end
    end

  end

  describe '#transform' do
    let(:text) { 'Lorem ipsum dolor sit amet' }
    let(:result) { checker.send(:transform, text, options) }

    context 'when there are no options' do
      let(:options) { [] }

      it 'doesnt modify the text' do
        expect(result).to eq 'Lorem ipsum dolor sit amet'
      end
    end

    context 'when there are options' do
      let(:options) { [IgnoreWhitespace, IgnoreCase] }

      it 'aplies thems' do
        expect(result).to eq 'loremipsumdolorsitamet'
      end
    end

  end

  describe '#options_for' do
    let(:options) { checker.send(:options_for, test_definition) }

    context 'when it is a string' do
      let(:test_definition) { 'Hey!' }

      it 'returns an empty list' do
        expect(options).to be_empty
      end
    end

    context 'when it is a hash' do

      context 'and there are no options' do
        let(:test_definition) { Hash.new }

        it 'returns an empty list' do
          expect(options).to be_empty
        end

      end

      context 'and there are options' do
        let(:test_definition) { {ignore_whitespace: true, ignore_case: true} }

        it 'returns a list with each option as object' do
          expect(options).to contain_exactly IgnoreCase, IgnoreWhitespace
        end
      end

    end
  end
end
