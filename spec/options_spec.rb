require_relative './spec_helper'

describe 'Options' do
  let(:input) { 'Lorem ipsum dolor sit amet' }

  context IgnoreCase do
    let(:parsed_input) { IgnoreCase.apply(input) }

    it 'returns the text in lowercase' do
      expect(parsed_input).to eq 'lorem ipsum dolor sit amet'
    end
  end

  context IgnoreWhitespace do
    let(:parsed_input) { IgnoreWhitespace.apply(input) }

    it 'returns the text without spaces' do
      expect(parsed_input).to eq 'Loremipsumdolorsitamet'
    end
  end
end
