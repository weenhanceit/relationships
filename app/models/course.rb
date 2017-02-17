##
# Represents a course.
class Course < ApplicationRecord
  has_many :sections, inverse_of: :course, autosave: true, dependent: :destroy
  has_many :sessions, through: :sections
end
