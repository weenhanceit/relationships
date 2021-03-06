##
# Represents a course for a particular group of students,
# given at a particular session. There may be mulitple instances of a course
# given during a session.
class Section < ApplicationRecord
  belongs_to :session, inverse_of: :sections
  belongs_to :course, inverse_of: :sections
  has_many :enrollments, inverse_of: :section, autosave: true, dependent: :destroy
  has_many :students, through: :enrollments
end
