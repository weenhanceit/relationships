class AddressPerson < ApplicationRecord
  # It appears you have to make this optional if you use
  # accepts_nested_attributes_for. Probably something order-related
  # in the checking.
  belongs_to :address, optional: true
  accepts_nested_attributes_for :address, allow_destroy: true

  belongs_to :person, optional: true
end
