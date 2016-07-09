class AddressPerson < ApplicationRecord
  belongs_to :address
  belongs_to :person
end
