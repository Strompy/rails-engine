class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoices

  def self.search(search_params)
    merchants = Array.new
    search_params.each do |attribute, search|
      merchants << where("cast(#{attribute} as text) ILIKE ?", "%#{sanitize_sql_like(search)}%")
    end
    merchants.flatten
  end
end
