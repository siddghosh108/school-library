def save_data
  save_books
  save_people
  save_rentals
end

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
