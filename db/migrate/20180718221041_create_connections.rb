class CreateConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :connections do |t|
      t.belongs_to :person_a, foreign_key: true, index: true
      t.belongs_to :person_b, foreign_key: true, index: true

      t.timestamps
    end
  end
end
