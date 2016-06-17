require 'spec_helper'

describe Placement do
  let(:placement) { FactoryGirl.create(:placement) }
  subject { placement }

  it { should respond_to(:order_id) }
  it { should respond_to(:product_id) }
  it { should respond_to(:quantity) }

  it { should belong_to(:order) }
  it { should belong_to(:product) }

  describe '#decrement_product_quantity!' do
    it 'should decreases the product quantity by the placement quantity' do
      product = placement.product
      expect{placement.decrement_product_quantity!}.to change{product.quantity}.by(-product.quantity)
    end
  end

end
