require_relative 'app'
require_relative 'execute_option'
app = App.new

# rubocop:disable Metrics/CyclomaticComplexity
def main(app)
  app.load_data
  puts 'Welcome to School Library App!'
  loop do
    puts 'Please choose an option by entering a number:'
    puts '1 - List all books'
    puts '2 - List all people'
    puts '3 - Create a person'
    puts '4 - Create a book'
    puts '5 - Create a rental'
    puts '6 - List all rentals for a given person id'
    puts '7 - Exit'

    number = gets.chomp.to_i
    break if number == 7

    case number
    when 1
      app.list_books
    when 2
      app.list_people
    when 3
      app.create_person
    when 4
      app.create_book
    when 5
      app.create_rental
    when 6
      app.list_rentals
    else
      puts 'Invalid option. Please enter a valid number.'
    end
  end
end

at_exit do
  app.save_data
end
# rubocop:enable Metrics/CyclomaticComplexity

main(app)
