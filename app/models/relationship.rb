class Relationship < ApplicationRecord
  # Putting `inverse_of` on the next two causes tests to fail if you don't
  # put the right association as the inverse (obviously).
  belongs_to :parent, class_name: "Person", inverse_of: :child_links
  belongs_to :child, class_name: "Person", inverse_of: :parent_links
  # https://thoughtbot.com/blog/accepts-nested-attributes-for-with-has-many-through
  accepts_nested_attributes_for :child
end
