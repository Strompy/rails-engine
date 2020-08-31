
namespace :db do
  desc "Seeds DB from csv files"
    task import: :environment do
  # destroy all first?
    data = {
      Customer => 'db/data/customers.csv',
      InvoiceItem => 'db/data/invoice_items.csv',
      Invoice => 'db/data/invoices.csv',
      Item => 'db/data/items.csv',
      Merchant => 'db/data/merchants.csv',
      Transaction => 'db/data/transactions.csv'
    }

    data.each do |type, path|
      type.destroy_all
      CSV.foreach(path, headers: true) do |row|
        if row["unit_price"]
          row["unit_price"] = row["unit_price"].to_f / 100
        end
        type.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!
    end
  end
end
