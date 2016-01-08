require 'spec_helper'
require 'yaml'

describe TestCompiler do
  before { I18n.locale = :en }

  let(:runner) { TestRunner.new }

  describe 'with ignore whitespace option' do
    let(:comparer) { EqualityComparer.new({equal: '1 + 2'}, [IgnoreWhitespace.new]) }

    it { expect(comparer.successful_for? '1+2').to eq true }
  end
end
