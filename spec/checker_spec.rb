require_relative './spec_helper'

describe TextChecker do
  let(:checker) { TextChecker.new }
  let(:example) { { name: 'test', postconditions: assertions } }
  subject { checker.check({source: source}, example) }

  context 'when using plain assertions' do
    let(:assertions) { { equal: 'hello' } }

    context 'when pass using numerical values' do
      let(:assertions) { { equal: 42 } }
      let(:source) { '42' }
      it { is_expected.to eq ['test', :passed, nil] }
    end

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
    let(:assertions) { { equal: {expected: 'HELLO', ignore_case: true } } }

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
    let(:assertions) { { equal: {expected: 'hello world', ignore_whitespace: true } } }

    context 'when pass' do
      let(:source) { '  hello    world' }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when pass without spaces' do
      let(:source) { 'helloworld' }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when do not pass' do
      let(:source) { 'hey jude' }
      it { is_expected.to eq ['test', :failed, '**hey jude** is not the right value.'] }
    end
  end

  context 'when using multiline flags' do
    let(:assertions) { { equal: {expected: "hello\nworld", multiline: true } } }

    context 'when pass with carriage return' do
      let(:source) { "hello\r\nworld" }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when pass without carriage return' do
      let(:source) { "hello\nworld" }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when do not pass' do
      let(:source) { 'hey jude' }
      it { is_expected.to eq ['test', :failed, '**hey jude** is not the right value.'] }
    end
  end

  context 'when using lenient blanks flags' do
    let(:assertions) { { equal: {expected: 'hello world', lenient_blank: true } } }

    context 'when pass' do
      let(:source) { 'hello    world' }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when pass with tabs' do
      let(:source) { "hello\tworld" }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when pass with mixed tabs and spaces' do
      let(:source) { "hello \tworld" }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when do not pass without spaces' do
      let(:source) { 'helloworld' }
      it { is_expected.to eq ['test', :failed, "**helloworld** is not the right value."] }
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

    context 'when pass using numerical values' do
      let(:assertions) { { keys: { question: { equal: '?' }, answer: { contain: 42 } } } }
      let(:source) { { question: '?', answer: '42' }.to_yaml }

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
      let(:source) { { name: 'Ada', lastname: 'byron' }.to_yaml }
      it { is_expected.to eq ['test', :failed, '**** is not the right value.'] }
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
          name: { equal: { expected: 'Ada', error: 'must be called Ada'} }
        }
      }
    }

    context 'when pass' do
      let(:source) { { name: 'Ada', surname: 'countess of lovelace' }.to_yaml }
      it { is_expected.to eq ['test', :passed, nil] }
    end

    context 'when do not pass' do
      let(:source) { { name: 'Ada', surname: 'byron' }.to_yaml }
      it { is_expected.to eq ['test', :failed, '**byron** does not contain the right value.'] }
    end

    context 'when do not pass with custom error message' do
      let(:source) { { name: 'Aida', surname: 'Lovelace' }.to_yaml }
      it { is_expected.to eq ['test', :failed, 'must be called Ada'] }
    end

  end
end
