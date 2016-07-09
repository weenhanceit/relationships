class CreateAddressPeople < ActiveRecord::Migration[5.0]
  def change
    create_table :address_people do |t|
      t.references :address, foreign_key: true
      t.references :person, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
