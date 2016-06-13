require 'spec_helper'

class Authentication
  include Authenticable
end

describe Authenticable do

  let(:authentication) { Authentication.new }

  subject { authentication }

  describe '#current user' do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      request.headers['Authorization'] = user.auth_token
      authentication.stub(:request).and_return(request)
    end

    it 'should returns the user from the authorization header' do
      expect(authentication.current_user.auth_token).to eql(user.auth_token)
    end

  end
end