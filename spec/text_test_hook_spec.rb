require_relative './spec_helper'

describe TextTestHook do
  let(:text_hook) { TextTestHook.new }
  let(:test_definition) { {source: 'Lorem ipsum', examples: examples} }
  let(:examples) { [{name: 'test1', postconditions: postcondition}] }

  describe '#compile' do
    let(:compilation) { text_hook.compile(request) }
    let(:request) do
      {content: ' Lorem ipsum ',
       test: "- name: 'test1'\n  postconditions:\n    equal: 'Lorem ipsum'"}
    end

    it 'removes trailing whitespaces from source' do
      expect(compilation[:source]).to eq 'Lorem ipsum'
    end

    context 'deserializes YAML example' do
      let(:postcondition) { {equal: 'Lorem ipsum'} }

      it { expect(compilation).to eq test_definition }
    end

  end

  describe '#run!' do
    let(:result) { text_hook.run!(test_definition).flatten }

    context 'when it passes' do
      let(:postcondition) { {equal: 'Lorem ipsum'} }


      it { expect(result).to contain_exactly 'test1', :passed, nil }
    end

    context 'when it fails' do
      let(:postcondition) { {equal: 'Oops'} }

      it { expect(result).to include 'test1', :failed }
    end

  end
end
