class CreateProvinces < ActiveRecord::Migration[5.0]
  def change
    create_table :provinces do |t|
      t.string :province_code
      t.string :province_name

      t.timestamps
    end
  end
end
