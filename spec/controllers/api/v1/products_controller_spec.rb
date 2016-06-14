require 'spec_helper'

describe Api::V1::ProductsController do

  describe 'GET #show' do
    let(:product) { FactoryGirl.create(:product) }
    before(:each) do
      get :show, id: product.id
    end

    it 'should return the informations about a reporter on a hash' do
      product_response = json_response
      expect(product_response[:title]).to eql(product.title)
    end

    it { should respond_with 200 }

  end

  describe 'GET #index' do
    before(:each) do
      4.times { FactoryGirl.create(:product) }
      get :index
    end

    it 'should returns 4 records from the database' do
      products_response = json_response
      expect(products_response).to have(4).items
    end

    it { should respond_with 200 }

  end

end
