require_relative('../db/sql_runner.rb')

class Ticket

attr_reader :id
attr_accessor :film_id, :customer_id 

def initialize(options)
  @id = options["id"].to_i if options["id"]
  @film_id = options["film_id"]
  @customer_id = options["customer_id"].to_i
end

  # MVP.2 - CRUD actions (create, read, update, delete) customers, films and tickets.

  def save()
    sql = "INSERT INTO tickets
    (
      film_id,
      customer_id
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@film_id, @customer_id]
    ticket = SqlRunner.run(sql, values).first
    @id = ticket['id'].to_i
  end
  
  def update() 
    sql = "UPDATE tickets SET 
    (
      film_id,
      customer_id
    )
    =
    (
      $1, $2
    )
    WHERE id = $3"
    values = [@film_id, @customer_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end 

  def self.all()
    sql = "SELECT * FROM tickets"
    ticket_data = SqlRunner.run(sql)
    return Ticket.map_items(ticket_data)
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end
  
  def self.map_items(ticket_data)
    result = ticket_data.map{|ticket| Ticket.new(ticket)}
    return result
  end

end