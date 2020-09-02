require 'rails_helper'

RSpec.describe "Merchant Search" do
  describe "Single Finder" do
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
    it "returns an item searched by ID" do
      get "/api/v1/items/find?id=#{@item1.id}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_merchant = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_merchant.count).to eq(1)
      expect(search_merchant[:type]).to eq("merchant")
      expect(search_merchant[:id]).to eq(@merchant1.id.to_s)
      expect(search_merchant[:attributes][:name]).to eq(@merchant1.name)
    end
  end
end
