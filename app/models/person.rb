class Person < ApplicationRecord
  belongs_to :user, optional: true

  has_many :address_people, inverse_of: :person
  accepts_nested_attributes_for :address_people
  # reject_if: :all_blank
  has_many :addresses, through: :address_people

  has_many :phones, inverse_of: :person
  accepts_nested_attributes_for :phones,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :parent_links,
           foreign_key: :child_id,
           class_name: "Relationship",
           dependent: :destroy
  accepts_nested_attributes_for :parent_links, allow_destroy: true
  has_many :parents, through: :parent_links, class_name: "Person"

  has_many :child_links,
           foreign_key: :parent_id,
           class_name: "Relationship",
           dependent: :destroy
  accepts_nested_attributes_for :child_links, allow_destroy: true
  has_many :children, through: :child_links, class_name: "Person"

  def address_types
    address_people.map(&:address_type).uniq
  end

  def to_json
    pp as_json.merge(addresses: addresses.as_json).merge(phones: phones.as_json)
  end
end
