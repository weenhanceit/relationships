class Phone < ApplicationRecord
  belongs_to :person, inverse_of: :phones
  accepts_nested_attributes_for :person
end
