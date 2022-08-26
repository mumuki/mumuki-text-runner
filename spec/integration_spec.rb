require_relative './spec_helper'

require 'active_support/all'

describe 'integration test' do
  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4567') }
  let(:response) { bridge.run_tests!(test) }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4567', err: '/dev/null'
    sleep 3
    I18n.locale = :en
  end

  after(:all) { Process.kill 'TERM', @pid }

  context 'when submission passes' do

    context 'given single scenario test' do
      let(:test) {
        {
          content: '    lorem IPSUM',
          test: %q{
            equal: 'lorem ipsum'
            ignore_case : true
            ignore_whitespace: true
          }
        }
      }

      it { expect(response).to eq valid_response('test') }
    end

    context 'given single, multiline scenario test' do
      let(:test) {
        {
          content: "name,surname,age\nFeli,Perez,24\nDani,Lopez,32\nJuani,Vazquez,19",
          test: %q{
            equal: "name,surname,age\nFeli,Perez,24\nDani,Lopez,32\nJuani,Vazquez,19"
            multiline: true
          }
        }
      }

      it { expect(response).to eq valid_response('test') }
    end

    context 'given single, multiline with carriage return in content' do
      let(:test) {
        {
          content: "name,surname,age\r\nFeli,Perez,24\r\nDani,Lopez,32\r\nJuani,Vazquez,19",
          test: %q{
            equal: "name,surname,age\nFeli,Perez,24\nDani,Lopez,32\nJuani,Vazquez,19"
            multiline: true
          }
        }
      }

      it { expect(response).to eq valid_response('test') }
    end

    context 'given single, multiline with carriage return in test' do
      let(:test) {
        {
          content: "name,surname,age\nFeli,Perez,24\nDani,Lopez,32\nJuani,Vazquez,19",
          test: %q{
            equal: "name,surname,age\r\nFeli,Perez,24\r\nDani,Lopez,32\r\nJuani,Vazquez,19"
            multiline: true
          }
        }
      }

      it { expect(response).to eq valid_response('test') }
    end


    context 'given single, mixed tabs and spaces in content' do
      let(:test) {
        {
          content: "zip  code,fiscal\taddress",
          test: %q{
            equal: "zip code,fiscal address"
            lenient_blank: true
          }
        }
      }

      it { expect(response).to eq valid_response('test') }
    end


    context 'given single, mixed tabs and spaces in test' do
      let(:test) {
        {
          content: "zip code,fiscal address",
          test: %q{
            equal: "zip\tcode,fiscal   address"
            lenient_blank: true
          }
        }
      }

      it { expect(response).to eq valid_response('test') }
    end

    context 'given single, multiline, lenient test' do
      let(:test) {
        {
          content: "\tname,surname,age\n\tFeli,Perez,24\n\tDani,Lopez,32\n\tJuani,Vazquez,19",
          test: %q{
            equal: "name,surname,age\nFeli,Perez,24\nDani,Lopez,32\nJuani,Vazquez,19"
            multiline: true
            lenient_blank: true
            ignore_whitespace: true
          }
        }
      }

      it { expect(response).to eq valid_response('test') }
    end

    context 'given simple format' do
      context 'match' do
        let(:test) {
          {
            content: 'Rainbow in the dark',
            test: %q{
            - name: 'regexpTest'
              postconditions:
                match: 'the dark'},
            extra: '' }
          }

        it { expect(response).to eq valid_response('regexpTest') }
      end

      context 'equal' do
        let(:test) {
          {
            content: 'Rainbow in the dark',
            test: %q{
            - name: 'equalityTest'
              postconditions:
                equal: 'Rainbow in the dark'},
            extra: '' }
          }

        it { expect(response).to eq valid_response('equalityTest') }
      end

      context 'contain' do
        let(:test) {
          {
            content: 'Rainbow in the dark',
            test: %q{
            - name: 'containTest'
              postconditions:
                contain: 'inbow'},
            extra: '' }
          }

        it { expect(response).to eq valid_response('containTest') }
      end
    end

    context 'given options' do
      context 'match' do
        let(:test) {
          {
            content: 'Rainbow in the dark',
            test: %q{
            - name: 'regexpTest'
              postconditions:
                match:
                  expected: 'the dark'
                  ignore_case: true
            },
            extra: '' }
         }

        it { expect(response).to eq valid_response('regexpTest') }
      end

      context 'equal' do
        let(:test) {
          {
            content: 'Rainbow in the dark',
            test: %q{
            - name: 'equalityTest'
              postconditions:
                equal:
                  expected: 'rAINBOW iN the dark'
                  ignore_case: true
            },
            extra: '' }
          }

        it { expect(response).to eq valid_response('equalityTest') }
      end

      context 'contain' do
        let(:test) {
          {
            content: 'Rainbow in the dark',
            test: %q{
            - name: 'containTest'
              postconditions:
                contain:
                  expected: 'DaRK'
                  ignore_case: true
            },
            extra: '' }
          }

        it { expect(response).to eq valid_response('containTest') }
      end

      describe 'keys mode' do
        let(:test) {
          {
            content: { first: 'walter white', second: 'hello, hello!', third: '0.0.0.0' }.to_yaml,
            test: test_spec,
            extra: ''
          }
        }

        describe 'standard test' do
          let(:test_spec) {%q{
            - name: 'miscTest'
              postconditions:
                keys:
                  first:
                    equal: walter white
                  second:
                    contain: hello
                  third:
                    valid_ip: true
          }}
          it { expect(response).to eq valid_response('miscTest') }
        end

        describe 'compact test' do
          let(:test_spec) {%q{
            - name: 'miscTest'
              keys:
                first:
                  equal: walter white
                second:
                  contain: hello
                third:
                  valid_ip: true
          }}
          it { expect(response).to eq valid_response('miscTest') }
        end
      end

      context 'valid_ip' do
        let(:test) {
          {
            content: '8.8.4.4',
            test: %q{
            - name: 'validIpTest'
              postconditions:
                valid_ip: true"
            },
            extra: '' } }

        it { expect(response).to eq valid_response('validIpTest') }
      end
    end
  end

  context 'when submission fails' do

    context 'given single scenario test' do
      let(:test) {
        {
          content: '    lorem IPSUM',
          test: %q{
            equal: 'Quux'
            ignore_case : true
            ignore_whitespace: true
          }
        }
      }

      it { expect(response).to eq invalid_response('test', '**lorem IPSUM** is not the right value.') }
    end

    context 'given simple format' do
      context 'match' do
        let(:test) { { content: 'Rainbow in the dark',
                       test: %q{
                        - name: 'regexpTest'
                          postconditions:
                            match: 'Quux'
                       },
                       extra: '' } }

        it { expect(response).to eq invalid_response('regexpTest', '**Rainbow in the dark** does not match the expected expression.') }
      end

      context 'equal' do
        let(:test) { { content: 'Rainbow in the dark',
                       test: %q{
                        - name: 'equalityTest'
                          postconditions:
                            equal: 'Quux'
                       },
                       extra: '' } }

        it { expect(response).to eq invalid_response('equalityTest', '**Rainbow in the dark** is not the right value.') }
      end

      context 'contain' do
        let(:test) { { content: 'Rainbow in the dark',
                       test: %q{
                        - name: 'containTest'
                          postconditions:
                            contain: 'Quux'
                       },
                       extra: '' } }

        it { expect(response).to eq invalid_response('containTest', '**Rainbow in the dark** does not contain the right value.') }
      end
    end

    context 'given options' do
      describe 'match' do
        context 'simple text' do
          let(:test) { { content: 'Rainbow in the dark',
                         test: %q{
                          - name: 'regexpTest'
                            postconditions:
                              match:
                                expected: 'the Dark'
                                ignore_case: true
                         },
                         extra: '' } }

          it { expect(response).to eq valid_response('regexpTest') }
        end

        context 'true regular expression' do
          context 'when valid' do
            let(:test) { {
                 content: '245.10.20.2',
                 test: %q{
- name: it is a proper ip
  postconditions:
    match: !ruby/regexp '/^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/'},
  extra: '' } }

            it { expect(response).to eq valid_response('it is a proper ip') }
          end

          context 'when invalid' do
            let(:test) { {
                 content: '1200.10.20.2',
                 test: %q{
- name: it is a proper ip
  postconditions:
    match: !ruby/regexp '/^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/'},
  extra: '' } }

            it { expect(response).to eq invalid_response('it is a proper ip',
              '**1200.10.20.2** does not match the expected expression.') }
          end
        end
      end

      context 'equal' do
        let(:test) { { content: 'Rainbow in the dark',
                       test: %q{
                        - name: 'equalityTest'
                          postconditions:
                            equal:
                              expected: 'Rainbow   in the dark'
                              ignore_case: true
                       },
                       extra: '' } }

        it { expect(response).to eq invalid_response('equalityTest', '**Rainbow in the dark** is not the right value.') }
      end

      context 'contain' do
        let(:test) { { content: 'Rainbow in the dark',
                       test: %q{
                        - name: 'containTest'
                          postconditions:
                            contain:
                              expected: 'DARRRk'
                              ignore_case: true
                       },
                       extra: '' } }

        it { expect(response).to eq invalid_response('containTest', '**Rainbow in the dark** does not contain the right value.') }
      end
    end
  end
end
