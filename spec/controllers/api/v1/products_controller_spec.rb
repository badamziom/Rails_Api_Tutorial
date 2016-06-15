require 'spec_helper'

describe Api::V1::ProductsController do

  describe 'GET #show' do
    let(:product) { FactoryGirl.create(:product) }
    before(:each) do
      get :show, id: product.id
    end

    it 'should return the information about a reporter on a hash' do
      product_response = json_response[:product]
      expect(product_response[:title]).to eql(product.title)
    end

    it 'should has the user as a embeded object' do
      product_response = json_response[:product]
      expect(product_response[:user][:email]).to eql(product.user.email)
    end

    it { should respond_with 200 }

  end

  describe 'GET #index' do
    before(:each) do
      4.times { FactoryGirl.create(:product) }
      get :index
    end

    context 'when is not receiving any product_ids parameter' do
      before(:each) do
        get :index
      end

      it 'should returns 4 records from the database' do
        products_response = json_response[:products]
        expect(products_response.size).to eq(4)
      end

      it 'should returns the user object into each product' do
        product_response = json_response[:products]
        product_response.each do |product_response|
          expect(product_response[:user]).to be_present
        end
      end

      it { should respond_with 200 }
    end

    context 'when is product_ids parameter is sent' do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) do
        3.times { FactoryGirl.create(:product, user: user) }
        get :index, product_ids: user.product_ids
      end

      it 'should returns just the products that belong to the user' do
        products_response = json_response[:products]
        p products_response.as_json
        products_response.each do |product_response|
        expect(product_response[:user][:email]).to eq(user.email)
      end

      end
    end

  end

  describe 'POST #creaate' do

    context 'when is successfully created' do
      let(:user) { FactoryGirl.create(:user) }
      let(:product_attributes) { FactoryGirl.attributes_for(:product) }
      
      before(:each) do
        api_authorization_header(user.auth_token)
        post :create, { user_id: user.id, product: product_attributes }
      end

      it 'should renders the json representation for the product record just created' do
        product_response = json_response[:product]
        expect(product_response[:title]).to eql(product_attributes[:title])
      end

      it { should respond_with 201 }
    end

    context 'when is successfully created' do
      let(:user) { FactoryGirl.create(:user) }
      let(:invalid_product_attributes) { { title: 'Smart TV', price: 'Twelve dollars' } }

      before(:each) do
        api_authorization_header(user.auth_token)
        post :create, { user_id: user.id, product: invalid_product_attributes }
      end

      it 'should renders an errors json' do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it 'should renders the json errors on while the product could not be created' do
        product_response = json_response
        expect(product_response[:errors][:price]).to include('is not a number')
      end

      it { should respond_with 422 }

    end
  end

  describe 'PUT/PATCH #update' do
    let(:user) { FactoryGirl.create(:user) }
    let(:product) { FactoryGirl.create(:product, user: user) }

    before(:each) do
      api_authorization_header(user.auth_token)
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, { user_id: user.id, id: product.id, product: { title: 'An expensive TV' } }
      end

      it 'should renders the json representation for the updated user' do
        product_response = json_response[:product]
        expect(product_response[:title]).to eql('An expensive TV')
      end

      it { should respond_with 200 }
      
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, { user_id: user.id, id: product.id, product: { price: 'two hundred' } }
      end

      it 'should renders an errors json' do
        product_reponse = json_response
        expect(product_reponse).to have_key(:errors)
      end

      it 'should renders the json on while the user could not be created' do
        product_reponse = json_response
        expect(product_reponse[:errors][:price]).to include('is not a number')
      end

      it { should respond_with 422 }

    end
  end

  describe 'DELETE #destroy' do
    let(:user) { FactoryGirl.create(:user) }
    let(:product) { FactoryGirl.create(:product, user: user) }

    before(:each) do
      api_authorization_header(user.auth_token)
      delete :destroy, { user_id: user.id, id: product.id }
    end

    it { should respond_with 204 }

  end

end
