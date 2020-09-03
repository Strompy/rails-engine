require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
  end
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
  end
  describe 'class methods' do
    before :each do
      Item.destroy_all
      Merchant.destroy_all
    end
    it "can search with search_params" do
      merchant = Merchant.create!(name: "Cool stuff")

      search_params = { name: "Cool"}
      expect(Merchant.search(search_params)).to eq([merchant])
    end
  end
end
