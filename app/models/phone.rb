class Phone < ApplicationRecord
  belongs_to :person, inverse_of: :phones
end
