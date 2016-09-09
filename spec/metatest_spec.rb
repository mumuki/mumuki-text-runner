require_relative './spec_helper'

describe 'metatest' do

  let(:result) { framework.test compilation, test_cases }
  let(:framework) do
    Mumukit::Metatest::Framework.new checker: TextServer::Checker.new,
                                     runner: Mumukit::Metatest::IdentityRunner.new
  end


  context 'when it is an equality test' do

    let(:compilation) do
      {
        content: 'consectetur adipiscing elit.',
        equal: 'test'
      }

    end

    let(:test_cases) {
      [{
         name: 'Lorem ipsum',
         postconditions: {equal: 'Hey!'}
       }]
    }

    xit { expect(result[0][0]).to include 'Lorem ipsum' }

  end


end
