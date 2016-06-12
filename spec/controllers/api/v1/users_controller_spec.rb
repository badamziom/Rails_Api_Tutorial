require 'spec_helper'

describe Api::V1::UsersController do
  before(:each) { request.headers['Accept'] = 'application/vnd.marketplace.v1' }

  describe 'GET #show' do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      get :show, id: user.id, format: :json
    end

    it 'should returns the information about a reporter on a hash' do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql(user.email)
    end

    it { should respond_with 200 }

  end

  describe 'POST #create' do

    context 'when is successfully created' do
      let(:user_attributes) { FactoryGirl.attributes_for(:user) }
      before(:each) do
        post :create, { user: user_attributes }, format: :json
      end

      it 'should renders the json representation for the user record just created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql(user_attributes[:email])
      end

      it { should respond_with 201 }
      
    end

    context 'when is not created' do
      let(:invalid_user_attributes) { { password: '12345678', password_confirmation: '12345678' } }
      before(:each) do
        post :create, { user: invalid_user_attributes }, format: :json
      end

      it 'should renders an error json' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it 'should renders the json errors on why the user could not be created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include("can't be blank")
      end

      it { should respond_with 422 }

    end

  end

end
