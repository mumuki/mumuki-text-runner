require_relative './spec_helper'

describe TextChecker do
  let(:checker) { TextChecker.new }
  subject { checker.check({source: source}, {name: 'test', postconditions: assertions}) }

  context 'when using plain assertions' do
    let(:assertions) {{ equal: 'hello' }}

    context 'when pass' do
      let(:source) { 'hello' }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when do not pass' do
      let(:source) { 'world' }
      it { is_expected.to eq ['test', :failed, '**world** is not the right value.'] }
    end
  end

  context 'when using ignore case flags' do
    let(:assertions) {{ equal: {expected: 'HELLO', ignore_case: true} }}

    context 'when pass' do
      let(:source) { 'hello' }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when do not pass' do
      let(:source) { 'world' }
      it { is_expected.to eq ['test', :failed, '**world** is not the right value.'] }
    end
  end

  context 'when using ignore space flags' do
    let(:assertions) {{ equal: {expected: 'hello world', ignore_whitespace: true} }}

    context 'when pass' do
      let(:source) { '  hello    world' }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when do not pass' do
      let(:source) { 'hey jude' }
      it { is_expected.to eq ['test', :failed, '**hey jude** is not the right value.'] }
    end
  end

  context 'when using key flags' do
    let(:assertions) {
      {
        keys: {
          surname: { equal: { expected: 'Lovelace' } },
          name: { equal: { expected: 'Ada' } }
        }
      }
    }

    context 'when pass with yaml' do
      let(:source) { { name: 'Ada', surname: 'Lovelace' }.to_yaml }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when pass with json' do
      let(:source) { { name: 'Ada', surname: 'Lovelace' }.to_json }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when do not pass because of content' do
      let(:source) { { name: 'Ada', surname: 'lovelace' }.to_yaml }
      it { is_expected.to eq ['test', :failed, '**lovelace** is not the right value.'] }
    end

    context 'when do not pass because of format' do
      let(:source) { { name: 'Ada', surname: 'lovelace' }.to_yaml }
      it { is_expected.to eq ['test', :failed, '**lovelace** is not the right value.'] }
    end
  end

  context 'when using non-key combined flags' do
    let(:assertions) { { contain: { expected: 'b.c', ignore_whitespace: true, ignore_case: true } } }

    context 'when pass' do
      let(:source) { 'A . B . C' }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when do not pass' do
      let(:source) { 'A' }
      it { is_expected.to eq ['test', :failed, '**A** does not contain the right value.'] }
    end
  end

  context 'when using combined key flags' do
    let(:assertions) {
      {
        keys: {
          surname: { contain: { expected: 'lovelace', ignore_whitespace: true, ignore_case: true } },
          name: { equal: 'Ada' }
        }
      }
    }

    context 'when pass with yaml' do
      let(:source) { { name: 'Ada', surname: 'countess of lovelace' }.to_yaml }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when do not pass' do
      let(:source) { { name: 'Ada', surname: 'byron' }.to_yaml }
      it { is_expected.to eq ['test', :failed, '**byron** does not contain the right value.'] }
    end
  end
end
