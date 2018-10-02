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
      let(:test) { { content: '    lorem IPSUM',
                     test: "equal: 'lorem ipsum'\n"\
                           "ignore_case : true'\n"\
                           'ignore_whitespace: true' } }

      it { expect(response).to eq valid_response('test') }
    end

    context 'given simple format' do
      context RegexpComparator do
        let(:test) { { content: 'Rainbow in the dark',
                       test: "- name: 'regexpTest'\n  postconditions:\n    match: 'the dark'",
                       extra: '' } }

        it { expect(response).to eq valid_response('regexpTest') }
      end

      context EqualityComparator do
        let(:test) { { content: 'Rainbow in the dark',
                       test: "- name: 'equalityTest'\n  postconditions:\n    equal: 'Rainbow in the dark'",
                       extra: '' } }

        it { expect(response).to eq valid_response('equalityTest') }
      end

      context ContainComparator do
        let(:test) { { content: 'Rainbow in the dark',
                       test: "- name: 'containTest'\n  postconditions:\n    contain: 'inbow'",
                       extra: '' } }

        it { expect(response).to eq valid_response('containTest') }
      end
    end

    context 'given options' do
      context RegexpComparator do
        let(:test) { { content: 'Rainbow in the dark',
                       test: "- name: 'regexpTest'\n"\
                             "  postconditions:\n"\
                             "    match:\n"\
                             "     expected: 'the dark'\n"\
                             '     ignore_case: true',
                       extra: '' } }

        it { expect(response).to eq valid_response('regexpTest') }
      end

      context EqualityComparator do
        let(:test) { { content: 'Rainbow in the dark',
                       test: "- name: 'equalityTest'\n"\
                             "  postconditions:\n"\
                             "    equal:\n"\
                             "     expected: 'rAINBOW iN the dark'\n"\
                             '     ignore_case: true',
                       extra: '' } }

        it { expect(response).to eq valid_response('equalityTest') }
      end

      context ContainComparator do
        let(:test) { { content: 'Rainbow in the dark',
                       test: "- name: 'containTest'\n"\
                             "  postconditions:\n"\
                             "    contain:\n"\
                             "     expected: 'DaRK'\n"\
                             '     ignore_case: true',
                       extra: '' } }

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

      context ValidIpComparator do
        let(:test) { { content: '8.8.4.4',
                       test: "- name: 'validIpTest'\n"\
                             "  postconditions:\n"\
                             "    valid_ip: true",
                       extra: '' } }

        it { expect(response).to eq valid_response('validIpTest') }
      end
    end
  end

  context 'when submission fails' do

    context 'given single scenario test' do
      let(:test) { { content: '    lorem IPSUM',
                     test: "equal: 'Quux'\n"\
                           "ignore_case : true'\n"\
                           'ignore_whitespace: true' } }

      it { expect(response).to eq invalid_response('test', '**lorem IPSUM** is not the right value.') }
    end

    context 'given simple format' do
      context RegexpComparator do
        let(:test) { { content: 'Rainbow in the dark',
                       test: "- name: 'regexpTest'\n  postconditions:\n    match: 'Quux'",
                       extra: '' } }

        it { expect(response).to eq invalid_response('regexpTest', '**Rainbow in the dark** does not match the expected expression.') }
      end

      context EqualityComparator do
        let(:test) { { content: 'Rainbow in the dark',
                       test: "- name: 'equalityTest'\n  postconditions:\n    equal: 'Quux'",
                       extra: '' } }

        it { expect(response).to eq invalid_response('equalityTest', '**Rainbow in the dark** is not the right value.') }
      end

      context ContainComparator do
        let(:test) { { content: 'Rainbow in the dark',
                       test: "- name: 'containTest'\n  postconditions:\n    contain: 'Quux'",
                       extra: '' } }

        it { expect(response).to eq invalid_response('containTest', '**Rainbow in the dark** does not contain the right value.') }
      end
    end

    context 'given options' do
      describe RegexpComparator do
        context 'simple text' do
          let(:test) { { content: 'Rainbow in the dark',
                         test: "- name: 'regexpTest'\n"\
                               "  postconditions:\n"\
                               "    match:\n"\
                               "     expected: 'the Dark'\n"\
                               '     ignore_case: true',
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

      context EqualityComparator do
        let(:test) { { content: 'Rainbow in the dark',
                       test: "- name: 'equalityTest'\n"\
                             "  postconditions:\n"\
                             "    equal:\n"\
                             "     expected: 'Rainbow   in the dark'\n"\
                             '     ignore_case: true',
                       extra: '' } }

        it { expect(response).to eq invalid_response('equalityTest', '**Rainbow in the dark** is not the right value.') }
      end

      context ContainComparator do
        let(:test) { { content: 'Rainbow in the dark',
                       test: "- name: 'containTest'\n"\
                             "  postconditions:\n"\
                             "    contain:\n"\
                             "     expected: 'DARRRk'\n"\
                             '     ignore_case: true',
                       extra: '' } }

        it { expect(response).to eq invalid_response('containTest', '**Rainbow in the dark** does not contain the right value.') }
      end
    end
  end
end
