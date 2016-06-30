class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.text :line1
      t.text :line2
      t.text :city
      t.references :province, foreign_key: true
      t.text :postal_code

      t.timestamps
    end
  end
end
