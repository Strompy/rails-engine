require 'rails_helper'

RSpec.describe 'Merchants API' do
  before :each do
    Merchant.destroy_all

    10.times do
      Merchant.create!(
        name: Faker::Company.name
      )
    end
    @merchant = Merchant.first
  end

  it 'sends a list of merchants' do
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)['data']
    expect(response.content_type).to eq("application/json")
    expect(merchants.first["id"]).to eq(@merchant.id.to_s)
    expect(merchants.count).to eq(10)
    expect(merchants.first["type"]).to eq("merchant")
    expect(merchants.first["attributes"]["name"]).to eq(@merchant.name)
  end
  it "sends a single merchant" do
    merchant = Merchant.last

    get "/api/v1/merchants/#{merchant.id}"

    returned_merchant = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(response.content_type).to eq("application/json")
    expect(returned_merchant["id"]).to eq(merchant.id.to_s)
    expect(returned_merchant["id"]).to eq(merchant.id.to_s)
    expect(returned_merchant["attributes"]["name"]).to eq(merchant.name)
  end
  it "can create a merchant" do
    merchant_params = { name: "Business!" }
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/merchants', headers: headers, params: JSON.generate(merchant_params)

    merchant = Merchant.last
    returned_merchant = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(response.content_type).to eq("application/json")
    expect(returned_merchant["type"]).to eq("merchant")
    expect(returned_merchant["id"]).to eq(merchant.id.to_s)
    expect(returned_merchant["attributes"]["name"]).to eq(merchant_params[:name])
  end
  it "can update an existing merchant" do
    merchant_params = { name: "Business!" }
    expect(@merchant.name).to_not eq(merchant_params[:name])
    headers = { "Content-Type" => "application/json" }

    put "/api/v1/merchants/#{@merchant.id}", headers: headers, params: JSON.generate(merchant_params)
    returned_merchant = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(response.content_type).to eq("application/json")
    expect(returned_merchant["type"]).to eq("merchant")
    expect(returned_merchant["id"]).to eq(@merchant.id.to_s)
    expect(returned_merchant["attributes"]["name"]).to eq(merchant_params[:name])
  end
  it "can delete and existing merchant" do
    expect(Merchant.count).to eq(10)

    delete "/api/v1/merchants/#{@merchant.id}"

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(response.body).to be_empty
    expect(Merchant.count).to eq(9)
    expect{Merchant.find(@merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
