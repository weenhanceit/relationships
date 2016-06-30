class Address < ApplicationRecord
  belongs_to :province, optional: true
end
