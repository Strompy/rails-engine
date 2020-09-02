class Item < ApplicationRecord
  validates :name, presence: true
  validates :unit_price, presence: true
  validates :description, presence: true

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def self.search(search_params)
    items = Array.new
    search_params.each do |attribute, search|
      items << where("cast(#{attribute} as text) ILIKE ?", "%#{sanitize_sql_like(search)}%")
    end
    items.flatten
  end
end
