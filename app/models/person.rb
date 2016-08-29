class Person < ApplicationRecord
  belongs_to :user, optional: true
  has_many :address_people
  accepts_nested_attributes_for :address_people, allow_destroy: true
  has_many :addresses, through: :address_people
  has_many :phones
  accepts_nested_attributes_for :phones

  def address_types
    address_people.map(&:address_type).uniq
  end

  def to_json
    pp as_json.merge(addresses: addresses.as_json).merge(phones: phones.as_json)
  end
end
