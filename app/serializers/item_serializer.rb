class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :unit_price, :description, :merchant_id

  # belongs_to :merchant
end
