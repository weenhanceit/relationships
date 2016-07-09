class ChangeTypeColumnName < ActiveRecord::Migration[5.0]
  def change
    change_table :address_people do |t|
      t.rename :type, :address_type
    end
  end
end
