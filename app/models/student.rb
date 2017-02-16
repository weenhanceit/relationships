##
# Represents a student.
class Student < ApplicationRecord
  has_many :enrollments, inverse_of: :student, autosave: true
  has_many :sections, through: :enrollments
  has_many :courses, through: :sections
end
