require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of :status }
  end
  describe 'relationships' do
    it { should have_many :transactions }
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end
  describe 'class methods' do
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
            unit_price: 12.3,
            description: Faker::ChuckNorris.fact
          )
      end
      5.times do
          @merchant2.items.create!(
            name: Faker::Commerce.product_name,
            unit_price: 10,
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
    it "returns revenue between dates" do
      start_date = @item1.created_at.to_s[0..9]
      end_date = @invoice.updated_at.to_s[0..9]
      date_params = {start: start_date, end: end_date}

      expect(Invoice.revenue_between_dates(date_params)).to eq(214.5)
    end
  end
end
