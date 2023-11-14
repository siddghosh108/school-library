require_relative 'book'
require_relative 'person'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'
require_relative 'classroom'
require_relative 'preserve_data'
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

  def load_data
    load_books_data
    load_people_data
  end

  # load books data
  def load_books_data
    @books = ReadFile.new('books.json').read.map { |book| Book.new(book['title'], book['author']) }
  end

  # load people data
  def load_people_data
    people_data = ReadFile.new('people.json').read || []
    students = []
    teachers = []

    people_data.each do |person|
      if person['type'] == 'student'
        students.push(load_student_data(person))
      elsif person['type'] == 'teacher'
        teachers.push(load_teacher_data(person))
      end
    end

    @people = students + teachers
  end

  # load student data
  def load_student_data(data)
    age = data['age']
    name = data.key?('name') ? data['name'] : 'Unknown'
    student = Student.new(age, data['parent_permission'], name: name)
    student.id = data['id']
    student
  end

  # load teacher data
  def load_teacher_data(data)
    age = data['age']
    specialization = data['specialization']
    name = data.key?('name') ? data['name'] : 'Unknown'
    teacher = Teacher.new(age, specialization, name: name)
    teacher.id = data['id']
    teacher
  end

  def save_data
    SaveData.new().save_books
    SaveData.new().save_people
    SaveData.new().save_rentals
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
      puts 'ID: #{person_id}'
      rentals_data = ReadFile.new('rentals.json').read || []
      matching_rentals = rentals_data.select do |rental|
        rental['person']['id'].to_i == person_id.to_i
      end
      if matching_rentals.empty?
        puts 'No rentals found for the specified person ID.'
      else
        puts 'Rentals:'
        matching_rentals.each do |rental|
          #puts "Date: #{rental.date}, Book '#{rental.book.title}' by #{rental.book.author}"
          puts "Date: #{rental['date']}, Book '#{rental['book']['title']}' by #{rental['book']['author']}"

          person_type = rental['person']['type']
          person_id = rental['person']['id']
          person_age = rental['person']['age']
          person_name = rental['person']['name']

          puts "Person Type: #{person_type}"
          puts "Person ID: #{person_id}"
          puts "Person Age: #{person_age}"
          puts "Person Name: #{person_name}"
          puts '--------------------'
        end
      end
    end
  end
end
