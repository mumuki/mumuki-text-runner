require_relative '../spec_helper'

describe HashedConfiguration do

  describe '#hash_configuration' do
    let(:comparator) {
      fooComparator = Class.new
      fooComparator.send :include, HashedConfiguration
      fooComparator.new
    }

    context 'given a hash' do

      it 'returns the same hash' do
        config = { expected: 'Quux', ignore_whitespace: true, ignore_case: true }
        expect(comparator.hash_configuration(config)).to be config
      end
    end

    context 'given a string' do

      it 'returns a hash with expected key' do
        expect(comparator.hash_configuration('Bar')).to eq expected: 'Bar'
      end
    end
  end
end
