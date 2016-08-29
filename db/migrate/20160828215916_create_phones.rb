class CreatePhones < ActiveRecord::Migration[5.0]
  def change
    create_table :phones do |t|
      t.string :number
      t.string :phone_type
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
