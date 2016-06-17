class ProductSerializer < ActiveModel::Serializer
  cache

  attributes :id, :title, :price, :published
  has_one :user
end
