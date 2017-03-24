# How Rails Implements Associations

* From the Rails docs and code, the class hierarchy is:  
  ```
  Association  
    SingularAssociation  
      HasOneAssociation + ForeignAssociation  
        HasOneThroughAssociation + ThroughAssociation  
      BelongsToAssociation  
        BelongsToPolymorphicAssociation  
    CollectionAssociation  
      HasManyAssociation + ForeignAssociation  
        HasManyThroughAssociation + ThroughAssociation  
  ```
* Code is in `rails/activerecord/lib/active_record`
* Association codes is in the above plus `associations`
* Autosave is in `rails/activerecord/lib/active_record/autosave_association.rb`. This is a module that presumably gets mixed in with an association
* At line 408 in above we save the associated record without validation.
I'm pretty sure that that's because the record has been validated already. Interestingly, since the records were all new it validates based on the association. So that's how it sneaks in that it saves without the ID
* So a really good question is how does the `belongs_to` side gets its foreign key IDs? It looks like it depends on the association type. For `has_many`,
they are set by `insert_record`
* The problem I was having was because the association callback
for `has_many` wasn't re-entrant. I made it re-entrant and it seems to work
