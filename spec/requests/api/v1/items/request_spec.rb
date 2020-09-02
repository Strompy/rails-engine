require 'rails_helper'

RSpec.describe "Items API" do
  before :each do
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
    @item = Item.first
  end

  it "sends a list of items" do
    get '/api/v1/items'


    parsed = JSON.parse(response.body, symbolize_names: true)
    items = parsed[:data]

    expect(response).to be_successful
    expect(response.content_type).to eq("application/json")
    expect(items.count).to eq(10)
    expect(items.first[:type]).to eq("item")
    expect(items.first[:id]).to eq(@item.id.to_s)
    expect(items.first[:attributes][:name]).to eq(@item.name)
    expect(items.first[:attributes][:unit_price].to_f).to eq(@item.unit_price.to_f)
    expect(items.first[:attributes][:description]).to eq(@item.description)
    expect(items.first[:attributes][:description]).to eq(@item.description)
    expect(items.first[:attributes][:merchant_id]).to eq(@item.merchant_id)
  end
end
