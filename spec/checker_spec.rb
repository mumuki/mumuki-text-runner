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
end
