require 'rails_helper'

RSpec.describe "Business Intelligence" do
  before :each do
    Merchant.destroy_all
    Item.destroy_all

    @customer = Customer.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
    @merchant1 = Merchant.create!(name: "Business!")
    @merchant2 = Merchant.create!(name: "Total Real Company, Inc.")
    @merchant3 = Merchant.create!(name: "Not a Ponzi")

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

      @invoice = @merchant2.invoices.create!(customer_id: @customer.id, status: 'shipped')
      InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice.id, quantity: 3, unit_price: @item2.unit_price)
      Transaction.create!(invoice_id: @invoice.id, result: 'success', credit_card_number: "1234556", credit_card_expiration_date: "")

  end
  it "returns total revenue across all merchants between the given dates" do
    start_date = @item1.created_at.to_s[0..9]
    end_date = @invoice.updated_at.to_s[0..9]

    get "/api/v1/revenue?start=#{start_date}&end=#{end_date}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    results = parsed[:data]

    expect(response).to be_successful
    expect(results[:id]).to eq('null')
    expect(results[:attributes][:revenue]).to_not be nil
  end
end
