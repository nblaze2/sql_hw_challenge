require 'pg'
require 'csv'
require 'pry'

system('psql drizly_hw < schema.sql')

def db_connection
  begin
    connection = PG.connect(dbname: 'drizly_hw')
    yield(connection)
  ensure
    connection.close
  end
end

db_connection do |conn|
  CSV.foreach('inv.csv', col_sep: '|', headers: true) do |row|
    conn.exec_params(
      'INSERT INTO inv (NAME, SIZE, SKU, INVPRICE) VALUES($1, $2, $3, $4)', [row['NAME'], row['SIZE'], row['SKU'], row['INVPRICE'].delete('$')]
    )
  end
  CSV.foreach('upc.csv', col_sep: '|', headers: true) do |row|
    #binding.pry
    conn.exec_params(
      'INSERT INTO upc (UPC, SKU) VALUES($1, $2)', [row['UPC'], row['SKU']]
    )
  end
  CSV.open('./combined.csv', 'w') do |csv|
    csv << ["NAME", "SIZE", "PRICE", "SKU", "UPC"]
    #binding.pry
    combined_inventory = conn.exec_params('SELECT inv.name, inv.size, inv.invprice AS PRICE, inv.sku, upc.upc FROM inv INNER JOIN upc ON inv.sku = upc.sku')
    combined_inventory.each do |item|
      csv << item.values_at('name', 'size', 'price', 'sku', 'upc')
    end
  end
end
