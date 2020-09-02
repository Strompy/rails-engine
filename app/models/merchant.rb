class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoices

  def self.search(search_params)
    merchants = Array.new
    search_params.each do |column, search|
      merchants << where("cast(#{column} as text) ILIKE ?", "%#{sanitize_sql_like(search)}%")
      # where("cast(id as text) ILIKE ?", "%2420%")
    end
    merchants.flatten
  end
end
