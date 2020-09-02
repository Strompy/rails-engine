require 'rails_helper'

RSpec.describe "Item Search" do
  describe 'Single Finder' do
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
      search_item = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_item[:type]).to eq("item")
      expect(search_item[:id]).to eq(@item1.id.to_s)
      expect(search_item[:attributes][:name]).to eq(@item1.name)
      expect(search_item[:attributes][:unit_price].to_f).to eq(@item1.unit_price.to_f)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:merchant_id]).to eq(@merchant1.id)
    end
    it "returns an item searched by full name, case insensitive" do
      get "/api/v1/items/find?name=#{@item1.name.downcase}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_item = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_item[:type]).to eq("item")
      expect(search_item[:id]).to eq(@item1.id.to_s)
      expect(search_item[:attributes][:name]).to eq(@item1.name)
      expect(search_item[:attributes][:unit_price].to_f).to eq(@item1.unit_price.to_f)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:merchant_id]).to eq(@merchant1.id)
    end
    it "returns an item searched by fragment of name, case insensitive" do
      get "/api/v1/items/find?name=#{@item1.name[1..3]}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_item = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_item[:type]).to eq("item")
      expect(search_item[:id]).to eq(@item1.id.to_s)
      expect(search_item[:attributes][:name]).to eq(@item1.name)
      expect(search_item[:attributes][:unit_price].to_f).to eq(@item1.unit_price.to_f)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:merchant_id]).to eq(@merchant1.id)
    end
    it "returns an item searched by fragment of created_at" do
      get "/api/v1/items/find?created_at=20"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_item = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_item[:type]).to eq("item")
      expect(search_item[:id]).to eq(@item1.id.to_s)
      expect(search_item[:attributes][:name]).to eq(@item1.name)
      expect(search_item[:attributes][:unit_price].to_f).to eq(@item1.unit_price.to_f)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:merchant_id]).to eq(@merchant1.id)
    end
    it "returns an item searched by fragment of updated_at" do
      get "/api/v1/items/find?updated_at=20"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_item = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_item[:type]).to eq("item")
      expect(search_item[:id]).to eq(@item1.id.to_s)
      expect(search_item[:attributes][:name]).to eq(@item1.name)
      expect(search_item[:attributes][:unit_price].to_f).to eq(@item1.unit_price.to_f)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:merchant_id]).to eq(@merchant1.id)
    end
    it "returns an item searched by fragment of description" do
      description_frag = @item1.description.split(" ").first
      get "/api/v1/items/find?description=#{description_frag}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_item = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_item[:type]).to eq("item")
      expect(search_item[:id]).to eq(@item1.id.to_s)
      expect(search_item[:attributes][:name]).to eq(@item1.name)
      expect(search_item[:attributes][:unit_price].to_f).to eq(@item1.unit_price.to_f)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:merchant_id]).to eq(@merchant1.id)
    end
    it "returns an item searched by whole unit_price" do
      get "/api/v1/items/find?unit_price=#{@item1.unit_price}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_item = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_item[:type]).to eq("item")
      expect(search_item[:id]).to eq(@item1.id.to_s)
      expect(search_item[:attributes][:name]).to eq(@item1.name)
      expect(search_item[:attributes][:unit_price].to_f).to eq(@item1.unit_price.to_f)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:merchant_id]).to eq(@merchant1.id)
    end
    it "returns an item searched by fragment of unit_price" do
      price_frag = @item1.unit_price.to_s[0..1]
      get "/api/v1/items/find?unit_price=#{price_frag}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_item = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_item[:type]).to eq("item")
      expect(search_item[:id]).to eq(@item1.id.to_s)
      expect(search_item[:attributes][:name]).to eq(@item1.name)
      expect(search_item[:attributes][:unit_price].to_f).to eq(@item1.unit_price.to_f)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:merchant_id]).to eq(@merchant1.id)
    end
    it "returns an item searched by merchants ID" do
      get "/api/v1/items/find?merchant_id=#{@item1.merchant_id}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_item = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      expect(search_item[:type]).to eq("item")
      expect(search_item[:id]).to eq(@item1.id.to_s)
      expect(search_item[:attributes][:name]).to eq(@item1.name)
      expect(search_item[:attributes][:unit_price].to_f).to eq(@item1.unit_price.to_f)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:description]).to eq(@item1.description)
      expect(search_item[:attributes][:merchant_id]).to eq(@merchant1.id)
    end
  end

  describe 'multi-finder' do
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
    it "returns items searched by ID fragment" do
      id_frag = @item1.id[0]
      get "/api/v1/items/find_all?id=#{id_frag}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_items = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      search_items.each do |search|
        expect(search[:type]).to eq("item")
        expect(search[:id]).to_not be nil
        expect(search[:attributes][:name]).to_not be nil
        expect(search[:attributes][:unit_price].to_f).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:merchant_id]).to_not be nil
      end
    end
    it "returns items searched by name fragment" do
      name_frag = @item1.name[0..2]
      get "/api/v1/items/find_all?id=#{name_frag}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_items = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      search_items.each do |search|
        expect(search[:type]).to eq("item")
        expect(search[:id]).to_not be nil
        expect(search[:attributes][:name]).to_not be nil
        expect(search[:attributes][:unit_price].to_f).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:merchant_id]).to_not be nil
      end
    end
    it "returns items searched by description fragment" do
      description_frag = @item1.description[0..2]
      get "/api/v1/items/find_all?id=#{description_frag}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_items = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      search_items.each do |search|
        expect(search[:type]).to eq("item")
        expect(search[:id]).to_not be nil
        expect(search[:attributes][:name]).to_not be nil
        expect(search[:attributes][:unit_price].to_f).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:merchant_id]).to_not be nil
      end
    end
    it "returns items searched by unit_price fragment" do
      price_frag = @item1.unit_price.to_s[0..1]
      get "/api/v1/items/find_all?id=#{price_frag}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_items = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      search_items.each do |search|
        expect(search[:type]).to eq("item")
        expect(search[:id]).to_not be nil
        expect(search[:attributes][:name]).to_not be nil
        expect(search[:attributes][:unit_price].to_f).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:merchant_id]).to_not be nil
      end
    end
    it "returns items searched by merchant_id" do
      merchant_id = @item1.merchant_id
      get "/api/v1/items/find_all?id=#{merchant_id}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_items = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      search_items.each do |search|
        expect(search[:type]).to eq("item")
        expect(search[:id]).to_not be nil
        expect(search[:attributes][:name]).to_not be nil
        expect(search[:attributes][:unit_price].to_f).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:merchant_id]).to_not be nil
      end
    end
    it "returns items searched by merchant_id fragment" do
      merchant_id_frag = @item1.merchant_id.to_s[0..1]
      get "/api/v1/items/find_all?id=#{merchant_id_frag}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_items = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      search_items.each do |search|
        expect(search[:type]).to eq("item")
        expect(search[:id]).to_not be nil
        expect(search[:attributes][:name]).to_not be nil
        expect(search[:attributes][:unit_price].to_f).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:merchant_id]).to_not be nil
      end
    end
    it "returns items searched by created_at fragment" do
      created_at_frag = @item1.created_at.to_s[0..1]
      get "/api/v1/items/find_all?id=#{created_at_frag}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_items = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      search_items.each do |search|
        expect(search[:type]).to eq("item")
        expect(search[:id]).to_not be nil
        expect(search[:attributes][:name]).to_not be nil
        expect(search[:attributes][:unit_price].to_f).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:merchant_id]).to_not be nil
      end
    end
    it "returns items searched by updated_at fragment" do
      updated_at_frag = @item1.updated_at.to_s[0..1]
      get "/api/v1/items/find_all?id=#{updated_at_frag}"

      parsed = JSON.parse(response.body, symbolize_names: true)
      search_items = parsed[:data]

      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
      search_items.each do |search|
        expect(search[:type]).to eq("item")
        expect(search[:id]).to_not be nil
        expect(search[:attributes][:name]).to_not be nil
        expect(search[:attributes][:unit_price].to_f).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:description]).to_not be nil
        expect(search[:attributes][:merchant_id]).to_not be nil
      end
    end
  end
end
