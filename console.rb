require_relative('models/ticket')
require_relative('models/film')
require_relative('models/customer')

require('pry-byebug')

Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

# MVP.1 - Create customers, films and tickets.

film1 = Film.new({
  'title' => 'CodeClan: The Movie',
  'price' => 10
})

film1.save()

film2 = Film.new({
  'title' => 'Gataca',
  'price' => 10
})

film2.save()

film3 = Film.new({
  'title' => 'Highlander',
  'price' => 10
})

film3.save()

customer1 = Customer.new({
  'name' => 'Sir Cody MacDuck',
  'funds' => 100
})

customer1.save()

customer2 = Customer.new({
  'name' => 'Vincent Freeman',
  'funds' => 5 
})

customer2.save()

customer3 = Customer.new({
  'name' => 'Duncan MacLeod',
  'funds' => 50
})

customer3.save()

ticket1 = Ticket.new({
  'film_id' => film1.id,
  'customer_id' => customer1.id
})

ticket1.save()

ticket2 = Ticket.new({
  'film_id' => film2.id,
  'customer_id' => customer2.id
})

ticket2.save()

ticket3 = Ticket.new({
  'film_id' => film3.id,
  'customer_id' => customer3.id
})

ticket3.save()

binding.pry
nil