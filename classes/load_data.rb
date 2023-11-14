class SaveData
    # save books
   def save_books
    # Store books data
    books_data = @books.map { |book| { title: book.title, author: book.author } }
    WriteFile.new('books.json').write(books_data)
  end

  # save people
  def save_people
    # Store people data only if there are people objects
    return unless @people.any?

    students_data = @people.select { |person| person.is_a?(Student) }.map do |student|
      { type: 'student', id: student.id, age: student.age, name: student.name }
    end

    teachers_data = @people.select { |person| person.is_a?(Teacher) }.map do |teacher|
      { type: 'teacher', id: teacher.id, age: teacher.age, name: teacher.name,
        specialization: teacher.specialization }
    end

    people_data = students_data + teachers_data
    WriteFile.new('people.json').write(people_data)
  end

  # save rentals
  def save_rentals
    # Store rentals data if available
    return unless @rentals.any?

    existing_rentals = ReadFile.new('rentals.json').read || []
    rentals_data = existing_rentals + @rentals.map do |rental|
      {
        date: rental.date,
        book: { title: rental.book.title, author: rental.book.author },
        person: { type: rental.person.class.to_s.downcase, id: rental.person.id, age: rental.person.age,
                  name: rental.person.name }
      }
    end
    WriteFile.new('rentals.json').write(rentals_data)
  end
end