class Invoice < ApplicationRecord
  validates :status, presence: true

  has_many :transactions
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  belongs_to :customer
  belongs_to :merchant

  def self.revenue_between_dates(date_params)
    start_date = date_params[:start]
    end_date = date_params[:end]
    Invoice.joins(:invoice_items, :transactions).
    where("transactions.result='success'").
    where(updated_at: Date.parse(start_date).beginning_of_day..Date.parse(end_date).end_of_day).
    sum("invoice_items.unit_price * invoice_items.quantity")
  end
end
