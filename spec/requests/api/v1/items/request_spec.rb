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
  it "can send a single item" do
    get "/api/v1/items/#{@item.id}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:data]

    expect(response).to be_successful
    expect(response.content_type).to eq("application/json")
    expect(item[:type]).to eq("item")
    expect(item[:id]).to eq(@item.id.to_s)
    expect(item[:attributes][:name]).to eq(@item.name)
    expect(item[:attributes][:unit_price].to_f).to eq(@item.unit_price.to_f)
    expect(item[:attributes][:description]).to eq(@item.description)
    expect(item[:attributes][:description]).to eq(@item.description)
    expect(item[:attributes][:merchant_id]).to eq(@item.merchant_id)
  end
  it "can create a new item" do
    item_params = {
      name: "Buy me",
      unit_price: 17.40,
      description: "Dont think buy",
      merchant_id: @merchant1.id
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item_params)

    item = Item.last
    returned_item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(response.content_type).to eq("application/json")
    expect(returned_item[:type]).to eq("item")
    expect(returned_item[:id]).to eq(item.id.to_s)
    expect(returned_item[:attributes][:name]).to eq(item.name)
    expect(returned_item[:attributes][:unit_price].to_f).to eq(item.unit_price.to_f)
    expect(returned_item[:attributes][:description]).to eq(item.description)
    expect(returned_item[:attributes][:description]).to eq(item.description)
    expect(returned_item[:attributes][:merchant_id]).to eq(item.merchant_id)
  end
end
