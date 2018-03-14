# Self-Referential Many-to-Many Save
A person can be a parent, or a child, or both. They can have more than one parent or child. If person A is person B's ancestor, person B can't also be a descendant of Person A. (The math and computer science people call this a [directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph))

In Rails, the easiest way to do this is to set up a `has_many :through` association for the parent, and another one for the child. Both will reference the same join table (`relationships` in this example).

The user interface is a list of check boxes for each person on the edit page of a person. Checking a box makes the checked person a child of the current person.
## Person
### Migration
```
rails g model person name:string
```
### Model
```
class Person < ApplicationRecord
  ...
  has_many :parent_links,
         foreign_key: :child_id,
         class_name: "Relationship",
         dependent: :destroy
  has_many :parents, through: :parent_links, class_name: "Person"
  accepts_nested_attributes_for :parents, allow_destroy: true
  has_many :child_links,
         foreign_key: :parent_id,
         class_name: "Relationship",
         dependent: :destroy
  has_many :children, through: :child_links, class_name: "Person"
  accepts_nested_attributes_for :children, allow_destroy: true
  ...
end
```
Note that the links are automatically destroyed if the person is destroyed. It's hard to think of a case where this is not the desired behaviour (but one might exist).
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
Postgres, MySql, MS SQL Server, and Oracle all automatically create an index for the primary key (the `id` column automatically created by the migration).

The `id` column is needed to directly delete relationships without deleting either the parent or the child.
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

## User Interface
[To find the API documentation for associations, go to `api.rubyonrails.org` and search for `ActiveRecord::Associations::ClassMethods`.]
### Simple
```
<%= person_form.collection_check_boxes(:child_ids,
                                       Person.all,
                                       :id,
                                       :name) %>
```
This is simple, but you'll have to arrange formatting by CSS styles appropriately selected to the `input`, for example, by putting them in a `div` with a particular class or id.

The `child_ids` method on the association, created automatically by Rails, is crucial to make this approach work.
### Formatting
You can give a block to `collection_check_boxes`, and that lets you take much more control of the formatting:
```
<ul>
  <%= person_form.collection_check_boxes(:child_ids,
                                         Person.all,
                                         :id,
                                         :name) do |box| %>
  <li>
    <%= box.check_box.concat(box.label) %>
  </li>
  <% end %>
</ul>
```
### Disabled Fields
By giving a block, you can also disable some fields. In the example, someone can't be their own child (not necessarily true of all applications of this pattern).
```
<ul>
<%= person_form.collection_check_boxes(:child_ids,
                                       Person.all,
                                       :id,
                                       :name) do |box| %>
  <li>
    <%= box.check_box(disabled: box.object == @person).concat(box.label) %>
  </li>
  <% end %>
</ul>
```
In fact, someone's ancestors can't be their child either:
```
<%= box.check_box(disabled: @person.and_ancestors.include?(box.object)).concat(box.label) %>
```
where `@person.and_ancestors` is an Enumerable of `@person` and all its ancestors.
### Permitted Parameters
The full list of permitted parameters depends on what appears in the view. This is the minimum to make the nest parameters work.
```
private

def person_params
  params.require(:person).permit(:id, child_ids: [])
end
```
## Enforcing the Acyclic Nature
The solution so far does not enforce the acyclic (ancestors can't be descendants and vice-versa) nature of this parent-child relationship.

The user should not be able to select as a child, any of its ancestors. Nor should it be able to select as a parent, any of its descendants. As long as the edit page only permits setting either the children or the parents, but not both, everything is fine the way it is, as long as the last part of "Disabled Fields" is used.

To set both parents and children on the same page, it gets trickier. Selecting a child changes which people are available as parents. And selecting a parent changes which people are available as children. Not only does this mean that actions on one part of the form are affecting a list on the other, but it raises questions about how the UI is arranged.

The issue with the UI and this "Ajaxy" approach is that the round trip to the server has not to change the database. 

First, set the page to show both parent and child lists. The permitted parameters are now:
```
private

def person_params
  params.require(:person).permit(:id, child_ids: [], parent_ids: [])
end
```
And the view is now:
```
<ul>
<%= person_form.collection_check_boxes(:child_ids,
                                       Person.all,
                                       :id,
                                       :name) do |box| %>
  <li>
    <%= box.check_box(disabled: @person.and_ancestors.include?(box.object)).concat(box.label) %>
  </li>
  <% end %>
</ul>
<ul>
<%= person_form.collection_check_boxes(:parent_ids,
                                       Person.all,
                                       :id,
                                       :name) do |box| %>
  <li>
    <%= box.check_box(disabled: @person.and_descendants.include?(box.object)).concat(box.label) %>
  </li>
  <% end %>
</ul>
```


Another approach would be to enforce it on the back end and simply return an error when the form is submitted. This isn't a great user experience in many cases, so it won't be covered here. It might be the easiest to implement, and therefore in some cases might be acceptable.
