require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :description }
  end
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end
  describe 'class methods' do
    it "can search with search_params" do
      merchant = Merchant.create!(name: "Cool stuff")
      item = merchant.items.create!(name: "Kool thing",
        unit_price: 10.12,
        description: "Hey, kool thing, come here, sit down
          Theres something i go to ask you.
          I just wanna know, what are you gonna do for me?
          I mean, are you gonna liberate us girls
          From male white corporate oppression?"
      )
      search_params = { name: "Kool thing"}
      expect(Item.search(search_params)).to eq([item])
    end
  end
end
