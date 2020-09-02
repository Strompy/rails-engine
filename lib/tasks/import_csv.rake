namespace :db do
  desc "Seeds DB from csv files"
    task import: :environment do
    data = {
      Customer => 'db/data/customers.csv',
      Merchant => 'db/data/merchants.csv',
      Item => 'db/data/items.csv',
      Invoice => 'db/data/invoices.csv',
      InvoiceItem => 'db/data/invoice_items.csv',
      Transaction => 'db/data/transactions.csv'
    }

    data.each do |type, path|
      puts "Destroying old #{type}s"
      type.destroy_all
      puts "Creating new #{type}s"
      CSV.foreach(path, headers: true) do |row|
        if row["unit_price"]
          row["unit_price"] = row["unit_price"].to_f / 100
        end
        type.create!(row.to_hash)
      end
    end
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end
end
