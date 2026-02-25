class CreateStudies < ActiveRecord::Migration[7.1]
  def change
    create_table :studies do |t|
      t.string :title, null: false
      t.string :topic
      t.text :description, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
