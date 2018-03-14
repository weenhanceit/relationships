class CreateSections < ActiveRecord::Migration[5.0]
  def change
    create_table :sections do |t|
      t.string :short_name
      t.belongs_to :session, foreign_key: true
      t.belongs_to :course, foreign_key: true
    end
  end
end
