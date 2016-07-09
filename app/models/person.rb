class Person < ApplicationRecord
  belongs_to :user, optional: true
  has_many :address_people
  has_many :addresses, through: :address_people

  def address_types
    address_people.map(&:address_type).uniq
  end
end
