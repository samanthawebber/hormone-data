class CreateSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :submissions do |t|
      t.references :study, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :values, null: false

      t.timestamps
    end

    add_index :submissions, [:study_id, :created_at]
  end
end
