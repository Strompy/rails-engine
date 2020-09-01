require 'rails_helper'

RSpec.describe 'Merchants API' do
  before :each do
    10.times do
      Merchant.create!(
        name: Faker::Company.name
      )
    end
  end

  it 'sends a list of merchants' do
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)['data']

    expect(merchants.count).to eq(10)
  end
  it "sends a single merchant" do
    merchant = Merchant.last

    get "/api/v1/merchants/#{merchant.id}"

    returned_item = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(returned_item["id"]).to eq(merchant.id.to_s)
  end
end
