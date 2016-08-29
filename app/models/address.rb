class Address < ApplicationRecord
  belongs_to :province, optional: true

  has_many :address_people, inverse_of: :address
  has_many :people, through: :address_people
end
