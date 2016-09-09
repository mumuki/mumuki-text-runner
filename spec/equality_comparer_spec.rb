require_relative './spec_helper'

describe TextTestHook do
  before { I18n.locale = :en }

  describe 'with ignore whitespace option' do
    let(:comparer) { EqualityComparer.new({equal: '1 + 2'}, [IgnoreWhitespace]) }

    it { expect(comparer.successful_for? '1+2').to eq true }
  end

  describe 'with many options' do
    let(:comparer) { EqualityComparer.new({equal: 'whatsup?'}, [IgnoreWhitespace, IgnoreCase]) }

    it { expect(comparer.successful_for? '  whAts UP?').to eq true }
  end
end
