class Person < ApplicationRecord
  belongs_to :user, optional: true
  has_many :address_people
  has_many :addresses, through: :address_people
end
