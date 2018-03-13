# Self-Referential Many-to-Many Save
## Person
### Migration
I don't remember.
### Model
```
class Person < ApplicationRecord
  ...
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
  ...
end
```
## Relationship
### Migration
```
rails g model relationship parent:references child:references
```
The above doesn't put indexes on the foreign keys. Make the migration look like this:
```
def change
  create_table :relationships do |t|
    t.references :parent, foreign_key: true, index: true
    t.references :child, foreign_key: true, index: true
    t.timestamps
  end
end
```
### Model
```
class Relationship < ApplicationRecord
  belongs_to :parent, class_name: "Person"
  belongs_to :child, class_name: "Person"
end
```
## How it Works
Unlike what I recall as my previous experiences, you can create a new Person, connect it to another new person *with `build`*, save the first Person, and everything will magically be in the database (even without `autosave: true`). Worth noting that the class has to be exactly perfect. I had something messed up in one of the `accepts_nested_attributes_for`, and it caused problems for the test cases, even though I didn't think I was using nested attributes.

It is possible that my problems were always when I was trying to do everything in memory. The relationship isn't bidirectional until it's saved.
