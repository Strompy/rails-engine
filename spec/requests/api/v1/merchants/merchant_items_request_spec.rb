require 'rails_helper'

RSpec.describe "Merchant Items Endpoint" do
  before :each do
    Merchant.destroy_all
    Item.destroy_all

    @merchant1 = Merchant.create!(name: "Business!")
    @merchant2 = Merchant.create!(name: "Total Real Company, Inc.")

    5.times do
        @merchant1.items.create!(
          name: Faker::Commerce.product_name,
          unit_price: Faker::Commerce.price,
          description: Faker::ChuckNorris.fact
        )
    end
    5.times do
        @merchant2.items.create!(
          name: Faker::Commerce.product_name,
          unit_price: Faker::Commerce.price,
          description: Faker::ChuckNorris.fact
        )
    end
    @item1 = Item.first
    @item2 = Item.last
  end

end
