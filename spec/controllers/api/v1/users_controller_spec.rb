require 'spec_helper'

describe Api::V1::UsersController do

  describe 'GET #show' do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      get :show, id: user.id
    end

    it 'should returns the information about a reporter on a hash' do
      user_response = json_response[:user]
      expect(user_response[:email]).to eql(user.email)
    end

    it 'should has the product ids as an embeded object' do
      user_response = json_response[:user]
      expect(user_response[:product_ids]).to eql([])
    end

    it { should respond_with 200 }

  end

  describe 'POST #create' do

    context 'when is successfully created' do
      let(:user_attributes) { FactoryGirl.attributes_for(:user) }
      before(:each) do
        post :create, { user: user_attributes }
      end

      it 'should renders the json representation for the user record just created' do
        user_response = json_response[:user]
        expect(user_response[:email]).to eql(user_attributes[:email])
      end

      it { should respond_with 201 }
      
    end

    context 'when is not created' do
      let(:invalid_user_attributes) { { password: '12345678', password_confirmation: '12345678' } }
      before(:each) do
        post :create, { user: invalid_user_attributes }
      end
      let(:user_response) { json_response }

      it 'should renders an error json' do
        expect(user_response).to have_key(:errors)
      end

      it 'should renders the json errors on why the user could not be created' do
        expect(user_response[:errors][:email]).to include("can't be blank")
      end

      it { should respond_with 422 }

    end
  end

  describe 'PUT/PATCH #update' do

    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      api_authorization_header(user.auth_token)
    end

    context 'when is successfully updated' do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) do
        patch :update, { id: user.id, user: { email: 'newmail@example.com' } }
      end
      let(:user_response) { json_response[:user] }

      it 'should renders the json representation for the updated user' do
        expect(user_response[:email]).to eql('newmail@example.com')
      end

      it { should respond_with 200 }

    end

    context 'when is not created' do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) do
        patch :update, { id: user.id, user: { email: 'badmail.com' } }
      end
      let(:user_response) { json_response }

      it 'should renders an errors json' do
        expect(user_response).to have_key(:errors)
      end

      it 'should renders the json errors on while the user could notbe created' do
        expect(user_response[:errors][:email]).to include('is invalid')
      end

      it { should respond_with 422 }

    end
  end

  describe 'DELETE #destroy' do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      api_authorization_header(user.auth_token)
      delete :destroy, { id: user.id }
    end

    it { should respond_with 204 }

  end

end
