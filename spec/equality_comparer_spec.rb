require_relative './spec_helper'

describe EqualityComparer do

  describe '#initialize' do
    let(:modifiers) { comparer.send :instance_variable_get, :@modifiers }
    let(:expected_value) { comparer.send :instance_variable_get, :@expected }

    context 'when given a string' do
      let(:comparer) { EqualityComparer.new('foo') }

      it { expect(modifiers).to be_empty }
      it { expect(expected_value).to eq 'foo' }
    end

    context 'when given a hash' do
      let(:comparer) { EqualityComparer.new(expected: 'foo', ignore_case: true) }

      it { expect(modifiers).to contain_exactly IgnoreCase }
      it { expect(expected_value).to eq 'foo' }
    end
  end

  describe '#satisfies?' do
    context 'without modifiers' do
      let(:comparer) { EqualityComparer.new('Foo') }

      it 'returns true if they are the same' do
        expect(comparer.satisfies?('Foo')).to be true
      end

      it 'returns false if they are different' do
        expect(comparer.satisfies?('Hey Arnold!')).to be false
      end
    end

    context 'with modifiers' do
      let(:comparer) { EqualityComparer.new(expected: 'foo', ignore_case: true) }

      it 'returns true if they are the same' do
        expect(comparer.satisfies?('Foo')).to be true
      end

      it 'returns false if they are different' do
        expect(comparer.satisfies?('Hey Arnold!')).to be false
      end
    end
  end

  describe '#locale_error_message' do
    let(:comparer) { EqualityComparer.new('Foo') }
    let(:error_message) { comparer.locale_error_message }

    before { comparer.satisfies?('Andrew') }

    context 'when language is English' do
      before { I18n.locale = :en }

      it { expect(error_message).to eq '**Andrew** is not the right value.' }
    end

    context 'when language is Spanish' do
      before { I18n.locale = :es }

      it { expect(error_message).to eq '**Andrew** no es el valor correcto.' }
    end
  end
end
