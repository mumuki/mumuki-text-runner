require_relative './spec_helper'

describe TextTestHook do
  let(:text_hook) { TextTestHook.new }

  describe '#compile' do
    let(:compilation) { text_hook.compile(request) }
    let(:request) do
      { content: ' Lorem ipsum ', test: "- name: 'test1'\n  postconditions:\n    equal: 'Lorem ipsum'" }
    end

    it 'parses one yaml example' do
      expect(compilation[:examples]).to contain_exactly name: 'test1',
                                                        postconditions: { equal: 'Lorem ipsum' }
    end

    it 'removes trailing whitespaces from source' do
      expect(compilation[:source]).to eq 'Lorem ipsum'
    end
  end

  describe '#run!' do
    let(:result) { text_hook.run!(test_definition) }
    let(:test_definition) do
      { source: 'Lorem ipsum', examples: [{ name: 'test1', postconditions: postcondition }] }
    end

    context 'when it passes' do
      let(:postcondition) { { equal: { expected: 'Lorem ipsum' } } }

      it { expect(result).to eq [[['test1', :passed, nil]]] }
    end

    context 'when it fails' do
      let(:postcondition) { { equal: { expected: 'Oops' } } }

      before { I18n.locale = :en }

      it { expect(result).to eq [[['test1', :failed, '**Lorem ipsum** is not the right value.']]] }
    end
  end
end
