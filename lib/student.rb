class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new  # self.new is the same as running Student.new
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student  # return the newly created instance
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT *
    FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_9
    # The method returns an array of all the students in grade 9.
    self.all.select do |row|
    row.grade == "9"
    end
  end

  def self.students_below_12th_grade
    # The method returns an array of all the students below grade 12.
    self.all.select do |row|
    row.grade < "12"
    end
  end

  def self.first_X_students_in_grade_10(x)
    # Takes in an argument of the number of students from grade 10 to select.
    #This method should return an array of exactly X number of students.
    tenth_grade_students_x = self.all.select do |row|
    row.grade == "10"
    end
    tenth_grade_students_x[1..x]
  end

  def self.first_student_in_grade_10
    #return the first student that is in grade 10.
    self.all.find do |row|
    row.grade == "10"
    end
  end

  def self.all_students_in_grade_X(x)
    #takes in an argument of grade for which to retrieve the roster.
    #Returns an array of all students for grade X.
    self.all.select do |row|
    row.grade == x.to_s
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

end
