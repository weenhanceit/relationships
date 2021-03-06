##
# Represents a student enrolled in a particular offering of a course.
class Enrollment < ApplicationRecord
  belongs_to :student, inverse_of: :enrollments
  belongs_to :section, inverse_of: :enrollments
end
