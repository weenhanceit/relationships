class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.references :parent, foreign_key: true, index: true
      t.references :child, foreign_key: true, index: true

      t.timestamps
    end
  end
end
