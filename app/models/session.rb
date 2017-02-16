##
# Represents a period during which the instituation offers courses.
class Session < ApplicationRecord
  has_many :sections, inverse_of: :session, autosave: true
  has_many :courses, through: :sections
end
