require_relative('../db/sql_runner.rb')

class Film

  attr_reader :id, :title, :price

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @title = options["title"]
    @price = options["price"].to_i
  end

  # MVP.2 - CRUD actions (create, read, update, delete) films, films and tickets.

  def save()
    sql = "INSERT INTO films 
    (
      title, 
      price
    ) 
    VALUES 
    (
      $1, $2
    ) 
    RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run(sql, values).first
    @id = film['id'].to_i
  end
  
  def update() 
    sql = "UPDATE films SET 
    (
      title,
      price
    )
    =
    (
      $1, $2
    )
    WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end 

  def self.all()
    sql = "SELECT * FROM films"
    film_data = SqlRunner.run(sql)
    return Film.map_items(film_data)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end
  
  def self.map_items(film_data)
    result = film_data.map{|film| Film.new(film)}
    return result
  end

  # MVP.3.2 - Show which customers are coming to see one film.
  
  def customers()
    sql = "
      SELECT customers.* FROM customers
      INNER JOIN tickets
      ON customers.id = tickets.customer_id
      WHERE tickets.film_id = $1
    "
    values = [@id]
    results = SqlRunner.run(sql, values)
    return Customer.map_items(results)
  end

  # EXTENSION.3 - Check how many customers are going to watch a certain film

  def how_many_customers()
    return customers().size()
  end 

end