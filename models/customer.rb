require_relative('../db/sql_runner.rb')

class Customer

  attr_reader :id, :name, :funds

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @name = options["name"]
    @funds = options["funds"].to_i
  end

  # MVP.2 - CRUD actions (create, read, update, delete) customers, films and tickets.

  def save() 
    sql = "INSERT INTO customers
    (
      name,
      funds
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update() 
    sql = "UPDATE customers SET 
    (
      name,
      funds
    )
    =
    (
      $1, $2
    )
    WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end
 
  def self.all() 
    sql = "SELECT * FROM customers"
    customer_data = SqlRunner.run(sql)
    return Customer.map_items(customer_data)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def self.map_items(customer_data)
    result = customer_data.map{|customer| Customer.new(customer)}
    return result
  end

  # MVP.3.1 - Show which films a customer has booked to see.

  def films()
    sql = "
      SELECT films.* FROM films
      INNER JOIN tickets
      ON films.id = tickets.film_id
      WHERE tickets.customer_id = $1
    "
    values = [@id]
    results = SqlRunner.run(sql, values)
    return Film.map_items(results)
  end

  # EXTENSION.1 - Buying tickets should decrease the funds of the customer by the price

  def decrease_funds(ticket_price) 
    @funds -= ticket_price
    update()
  end

  # EXTENSION.2 - Check how many tickets were bought by a customer

  def how_many_tickets()
    return films().size()
  end

end
