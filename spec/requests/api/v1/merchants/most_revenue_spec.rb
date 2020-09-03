require 'rails_helper'

RSpec.describe "Business Intelligence" do
  before :each do
    Merchant.destroy_all
    Item.destroy_all

    @customer = Customer.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
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
    5.times do
      invoice = @merchant1.invoices.create!(customer_id: @customer.id, status: 'shipped')
      InvoiceItem.create!(item_id: @item1.id, invoice_id: invoice.id, quantity: 3, unit_price: @item1.unit_price)
      Transaction.create!(invoice_id: invoice.id, result: 'success', credit_card_number: "1234556", credit_card_expiration_date: "")
    end
    1.times do
      invoice = @merchant2.invoices.create!(customer_id: @customer.id, status: 'shipped')
      InvoiceItem.create!(item_id: @item2.id, invoice_id: invoice.id, quantity: 3, unit_price: @item2.unit_price)
      Transaction.create!(invoice_id: invoice.id, result: 'success', credit_card_number: "1234556", credit_card_expiration_date: "")
    end
  end
  it "return a variable number of merchants ranked by total revenue" do
    get "/api/v1/merchants/most_revenue?quantity=2"

    parsed = JSON.parse(response.body, symbolize_names: true)
    results = parsed[:data]

    expect(response).to be_successful
    expect(response.content_type).to eq("application/json")
    expect(results.count).to eq(2)
    expect(results.first[:id]).to eq(@merchant1.id.to_s)
    expect(results.last[:id]).to eq(@merchant2.id.to_s)
    expect(results.first[:type]).to eq('merchant')
    expect(results.last[:type]).to eq('merchant')
    expect(results.first[:attributes][:name]).to eq(@merchant1.name)
    expect(results.last[:attributes][:name]).to eq(@merchant2.name)
  end
  it "return a single merchant ranked by total revenue" do
    get "/api/v1/merchants/most_revenue?quantity=1"

    parsed = JSON.parse(response.body, symbolize_names: true)
    results = parsed[:data]

    expect(response).to be_successful
    expect(response.content_type).to eq("application/json")
    expect(results.count).to eq(1)
    expect(results.first[:id]).to eq(@merchant1.id.to_s)
    expect(results.first[:type]).to eq('merchant')
    expect(results.first[:attributes][:name]).to eq(@merchant1.name)
  end
end
