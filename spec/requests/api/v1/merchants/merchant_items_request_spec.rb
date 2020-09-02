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
  it "sends all items that belong to the Merchant" do
     get "/api/v1/merchants/#{@merchant1.id}/items"

     parsed = JSON.parse(response.body, symbolize_names: true)
     items = parsed[:data]

     expect(response).to be_successful
     expect(response.content_type).to eq("application/json")
     expect(items.count).to eq(5)
     expect(items.first[:type]).to eq("item")
     expect(items.first[:id]).to eq(@item1.id.to_s)
     expect(items.first[:attributes][:name]).to eq(@item1.name)
     expect(items.first[:attributes][:unit_price].to_f).to eq(@item1.unit_price.to_f)
     expect(items.first[:attributes][:description]).to eq(@item1.description)
     expect(items.first[:attributes][:description]).to eq(@item1.description)
     expect(items.first[:attributes][:merchant_id]).to eq(@merchant1.id)
     expect(items.none? { |item| item[:attributes][:merchant_id] == @merchant2.id}).to be true
  end
end
