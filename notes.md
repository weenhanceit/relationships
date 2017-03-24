# Partials, Layouts, and Templates
* Partials (at least, maybe others) are searched up the file hierarchy.
In the default hierarchy, this isn't much, but you can of course build
your own hierarchy.
* `render` takes a block which the partial can yield.
* When you want to take advantage of the partial named after the model,
name the partial in the singular, but `render` a pluralized collection.
* The "polymorphic" partial trick depends on the partial named in the singular,
for the class/model. Question is, where does the model have to be?
* Variable naming in the partial is complicated.
A lot of the guide examples
show instance variables in the view,
but some other source recommends always doing a local variable,
as it makes it easier to use the partial from multiple views.
* Shared partials need to go in a shared folder,
or put them somewhere up the directory hierarchy.
* Forgetting to say `render partial: ...` leads to a weird error message
about "locals undefined."

# Associations
[A lot of the following needs to be confirmed and shown in examples.]
* Set it up right:
  * `optional`. New to Rails 5 and will cause grief if you're following
  older examples.
  * `inverse_of`. This doesn't apply/work? on `belongs_to`.
  * Polymorphic (`inverse_of` doesn't work here, either).
  * Consider if a default scope that orders the associated objects
  makes sense for the association.
  At the very least, it will likely make writing reliable
  tests a lot easier.
  One trick is that sometimes what you'd like for default ordering
  is too complicated for a database query,
  e.g. it's like "order on this unless it's nil in which case order on that."
  * `Class.includes(:association, :association, ...).find(...)`
  * Loading the dependent objects is something you do when you
  do the `find`, so it's not done on the association.
* Deleting dependent options on `accepts_nested_attributes_for` is interesting. Start with `allow_destroy: true`, but that's just for the `_delete` attribute
* `accepts_nested_attributes_for`:
  * Also have to set up the accepted parameters
  * Make sure `id` field is in the view/parameters
* The association will save all dependent objects if the association
is defined with `autosave: true`, or the model `accepts_nested_attributes_for`
the dependent
  * `autosave: true` sets up a number of callbacks. Put your callbacks after
  all the associations are defined in the model to avoid unexpected grief.
  see http://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html.
  * I obeserved on the Autism Funding app that the validations follow
  whatever is autosaved. This can lead to somewhat surprising behaviour,
  as, for example, an object, its parent, and all its siblings
  (descending from the parent) get validated.
* It's tempting to bang in the migration,
but you really should take the time to set up the foreign keys,
and the indexes for the obvious attributes.
* The obvious attributes are the primary key,
and any foreign keys,
unless you know that the table will always have very few rows
(e.g. it's a small look-up table).
* Typically set up `has_and_belongs_to_many` tables without an id,
and therefore set up the index on the two join ids.
You probably need two indexes,
because you want to be able to come from either side of the association.
* The Rails 5 migration generator creates indexes for join tables in a comment,
and they're reasonable candidates to just simply uncomment
* If you had a `has_and_belongs_to_many` join table that you need to
convert to `has_many through:`, don't forget the migration:
```
  rails g migration add_id_to_tablename id:primary_key
```
* `belongs_to` often behaves differently than `has_many`
  * `build_association(params)` on a `belongs_to` won't set up the inverse `has_many`,
  but `association.build(params)` or ` association << object`
  on the `has_many` _will_ set up the `belongs_to`.
  * The name of the part of the params hash for the associated model
  in a `belongs_to` appears to be different from the name given
  for the hash for a `has_many` association.
* `has_many through:` should be done totally manually.
Don't try to cheat by using anything that supports `has_and_belongs_to_many`,
like `create_join_table`. It won't work
* Doing `has_many through:` manually includes adding a primary key column.
Deletion doesn't work without the primary key
* If you want to do in-memory (before you save) computations with
`has_many :through`, you need to set both `has_many` sides of
the association to the join object. Also, the actual `has_many :through`
won't work unless you've saved the objects
* Strong parameters are a mystery:
  * `has_many`
  * `belongs_to`
  * `accepts_nested_attributes_for`

[Phil and I saw weird behaviour with bi-directional
`accepts_nested_attributes_for`, but it might have been
due to invalid data that got into the database somehow.]
[Also, check out scopes on `belongs_to`.]

# Validations and Error Handling
* The algorithm for where to put errors on validations
is not clear to me.
It seems like sometimes they get added to the parent,
and sometimes they don't.
* Also, it's not clear that validations propagate down the associations
when you call `valid?` or `validate`,
or just when you actually save.

# Routes
* Always use shallow routes.
* Shallow routes inside shallow routes will generate what you expect.

# Same Types in Different Models
E.g. Phone numbers or postal codes.
You need to validate them and normalize their format,
but they're just one field in various models.

## `attribute` Method
The `attribute` method lets you define a different class (more generally, type),
for your model attributes. I think this is what we need for generalizing
types across models.

The attribute type will only solve part of the problem.
You also need, amongst other things,
validators on the class

# Service Objects
http://brewhouse.io/blog/2014/04/30/gourmet-service-objects.html

# Concerns

# Examples
* People and phone numbers for `has_many` and `belongs_to`.
* Authors-books or Students-classes for `has_and_belongs_to_many`,
or more usefully `has_many through:`.
* Images or Forms for polymorphic.
* Parents-children/family trees, or "friends",
for a polymorphic,
`has_and_belongs_to_many`,
self-referential relationship.

# Form Builders
* The "add a child" approach from Railscasts.
  * Javascript
  * Helper
  * View
* The wonky syntax to make create and edit work with the same view,
when you have nested models in a view (the [child, parent] thing,
  or is it the other way around???)
