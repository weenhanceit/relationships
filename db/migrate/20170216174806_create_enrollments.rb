class CreateEnrollments < ActiveRecord::Migration[5.0]
  def change
    create_table :enrollments do |t|
      t.belongs_to :student, foreign_key: true
      t.belongs_to :section, foreign_key: true
      t.decimal :final_mark, precision: 5, scale: 2
    end
  end
end
