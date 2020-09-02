require 'rails_helper'

RSpec.describe "Item Merchant Endpoint" do
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
  it "sends the merchant that has the item" do
    get "/api/v1/items/#{@item1.id}/merchant"

    parsed = JSON.parse(response.body, symbolize_names: true)
    merchant = parsed[:data]

    expect(response).to be_successful
    expect(response.content_type).to eq("application/json")
    expect(merchant[:type]).to eq("merchant")
    expect(merchant[:id]).to eq(@merchant1.id.to_s)
    expect(merchant[:attributes][:name]).to eq(@merchant1.name)
  end
end
