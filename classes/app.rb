require_relative 'book'
require_relative 'person'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'
require_relative 'classroom'

class App
  def initialize
    @books = []
    @people = []
    @rentals = []
  end

  def create_person
    print 'Do you want to create a student (1) or a teacher (2)? [Input the number]: '
    type = gets.chomp.to_i
    case type
    when 1
      print 'Age: '
      age = gets.chomp.to_i
      print 'Name: '
      name = gets.chomp
      print 'Has parent permission? [Y/N]: '
      parent_permission = gets.chomp
      person = Student.new(age, parent_permission, name: name)
      @people.push(person)
      puts "Student '#{name}' created successfully"
    when 2
      print 'Age: '
      age = gets.chomp.to_i
      print 'Name: '
      name = gets.chomp
      print 'Specialization: '
      specialization = gets.chomp
      person = Teacher.new(age, specialization, name: name)
      @people.push(person)
      puts "Teacher '#{name}' created successfully"
    else
      puts 'Invalid input. Please enter 1 for a student or 2 for a teacher.'
    end
  end

  def create_book
    print 'Title: '
    title = gets.chomp
    print 'Author: '
    author = gets.chomp
    book = Book.new(title, author)
    @books.push(book)
    puts "Book '#{title}' created successfully"
  end

  def create_rental
    book_index = select_book
    person_index = select_person
    print 'Date: '
    date = gets.chomp
    @rentals.push(Rental.new(date, @books[book_index], @people[person_index]))
    puts 'Rental created successfully'
  end

  def select_book
    puts 'Select a book from the following list by number:'
    list_books
    gets.chomp.to_i
  end

  def select_person
    puts 'Select a person from the following list by number (not id):'
    list_people
    gets.chomp.to_i
  end

  def list_books
    @books.each_with_index do |book, index|
      puts "#{index} - Title: #{book.title}, Author: #{book.author}"
    end
  end

  def list_people
    @people.each_with_index do |person, index|
      type = person.instance_of?(Student) ? 'Student' : 'Teacher'
      puts "#{index} - [#{type}] Name: #{person.name}, ID: #{person.id}, Age: #{person.age}"
    end
  end

  def list_rentals
    if @rentals.empty?
      puts 'There are no rentals to show'
    else
      list_people
      print 'Enter the ID of the person to list rentals: '
      person_id = gets.chomp.to_i
      matching_rentals = @rentals.select { |rental| rental.person.id == @people[person_id].id }
      if matching_rentals.empty?
        puts 'No rentals found for the specified person ID.'
      else
        puts 'Rentals:'
        matching_rentals.each do |rental|
          puts "Date: #{rental.date}, Book '#{rental.book.title}' by #{rental.book.author}"
        end
      end
    end
  end
end
