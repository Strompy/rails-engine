class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  # has_many :customers, through: :invoices

  def self.search(search_params)
    merchants = Array.new
    search_params.each do |attribute, search|
      merchants << where("cast(#{attribute} as text) ILIKE ?", "%#{sanitize_sql_like(search)}%")
    end
    merchants.flatten
  end

  def self.find_most_revenue(revenue_params)
    quantity = revenue_params[:quantity]
    Merchant.joins(invoices: [:invoice_items, :transactions]).
    select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue").
    where("transactions.result='success'").
    group(:id).
    order("revenue DESC").
    limit(quantity)
  end

  def self.most_items_sold(most_items_params)
    quantity = most_items_params[:quantity]
    Merchant.joins(invoices: [:invoice_items, :transactions]).
    select("merchants.*, SUM(invoice_items.quantity) as sold").
    where("transactions.result='success'").
    group(:id).
    order("sold DESC").
    limit(quantity)
  end
end
