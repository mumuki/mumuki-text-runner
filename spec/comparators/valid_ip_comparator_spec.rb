require_relative '../spec_helper'

describe TextChecker::ValidIpComparator do
  describe '#success?' do
    let(:comparator) { TextChecker::ValidIpComparator.new }
    subject { comparator.success? actual }

    context 'when the ip is valid' do
      let(:actual) { '127.0.0.1' }

      it { is_expected.to be true }
    end

    context 'when the ip has characters' do
      let(:actual) { '127.0.0.1a' }
      it { is_expected.to be false }
    end

    context 'when the ip has values over 255' do
      let(:actual) { '127.999.0.1' }
      it { is_expected.to be false }
    end

    context 'when the ip has more than 4 octets' do
      let(:actual) { '100.200.300.400.500' }
      it { is_expected.to be false }
    end

    context 'when the ip has less than 4 octets' do
      let(:actual) { '1.2.3' }
      it { is_expected.to be false }
    end
  end

  describe '#error_message' do
    let(:comparator) { TextChecker::ValidIpComparator.new }
    subject { comparator.send(:error_message, 'Super mega ukulele') }

    context 'when language is English' do
      before { I18n.locale = :en }

      it { is_expected.to eq '**Super mega ukulele** is not a valid IP address.' }
    end

    context 'when language is Spanish' do
      before { I18n.locale = :es }

      it { is_expected.to eq '**Super mega ukulele** no es una dirección IP válida.' }
    end
  end
end
