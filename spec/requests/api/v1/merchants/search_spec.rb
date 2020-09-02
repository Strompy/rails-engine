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
    it "returns a merchant searched by ID" do
      get "/api/v1/merchants/find?id=#{@merchant1.id}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_merchant = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_merchant[:type]).to eq("merchant")
      expect(search_merchant[:id]).to eq(@merchant1.id.to_s)
      expect(search_merchant[:attributes][:name]).to eq(@merchant1.name)
    end
    it "returns a single merchant when searched by full name, case insensitive" do
      get "/api/v1/merchants/find?name=#{@merchant1.name.downcase}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_merchant = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_merchant[:type]).to eq("merchant")
      expect(search_merchant[:id]).to eq(@merchant1.id.to_s)
      expect(search_merchant[:attributes][:name]).to eq(@merchant1.name)
    end
    it "returns a single merchant when searched by fragment of name, case insensitive" do
      get "/api/v1/merchants/find?name=Al"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_merchant = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_merchant[:type]).to eq("merchant")
      expect(search_merchant[:id]).to eq(@merchant2.id.to_s)
      expect(search_merchant[:attributes][:name]).to eq(@merchant2.name)
    end
    it "returns a single merchant with created_at fragment" do
      get "/api/v1/merchants/find?created_at=2020"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_merchant = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_merchant[:type]).to eq("merchant")
      expect(search_merchant[:id]).to eq(@merchant1.id.to_s)
      expect(search_merchant[:attributes][:name]).to eq(@merchant1.name)
    end
    it "returns a single merchant with update_at fragment" do
      get "/api/v1/merchants/find?updated_at=2020"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_merchant = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_merchant[:type]).to eq("merchant")
      expect(search_merchant[:id]).to eq(@merchant1.id.to_s)
      expect(search_merchant[:attributes][:name]).to eq(@merchant1.name)
    end
  end
  describe "Multi-Finder" do
    before :each do
      Merchant.destroy_all
      Item.destroy_all

      @merchant1 = Merchant.create!(name: "Business!")
      @merchant2 = Merchant.create!(name: "Total Real Company, Inc.")
      @merchant3 = Merchant.create!(name: "No")

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
    it "returns matching merchants searched by ID fragment" do
      id_frag = @merchant1.id[0]
      get "/api/v1/merchants/find_all?id=#{id_frag}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_merchants = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")

      search_merchants.each do |search|
        expect(search[:type]).to eq("merchant")
        expect(search[:id]).to_not be nil
        expect(search[:attributes][:name]).to_not be nil
      end
    end
    it "returns matching merchants when searched by fragment of name, case insensitive" do
      get "/api/v1/merchants/find_all?name=E"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_merchants = parsed[:data]

      expect(response).to be_successful
      expect(search_merchants.count).to eq(2)

      search_merchants.each do |search|
        expect(search[:type]).to eq("merchant")
        expect(search[:id]).to_not be nil
        expect(search[:attributes][:name]).to_not be nil
      end
    end
    it "returns matching merchants with created_at fragment" do
      get "/api/v1/merchants/find_all?created_at=20"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_merchants = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_merchants.count).to eq(3)

      search_merchants.each do |search|
        expect(search[:type]).to eq("merchant")
        expect(search[:id]).to_not be nil
        expect(search[:attributes][:name]).to_not be nil
      end
    end
    it "returns a single merchant with update_at fragment" do
      get "/api/v1/merchants/find_all?updated_at=20"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_merchants = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_merchants.count).to eq(3)

      search_merchants.each do |search|
        expect(search[:type]).to eq("merchant")
        expect(search[:id]).to_not be nil
        expect(search[:attributes][:name]).to_not be nil
      end
    end
  end
end
