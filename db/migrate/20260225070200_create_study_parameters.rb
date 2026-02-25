class CreateStudyParameters < ActiveRecord::Migration[7.1]
  def change
    create_table :study_parameters do |t|
      t.references :study, null: false, foreign_key: true
      t.string :name, null: false
      t.string :unit
      t.decimal :min_value, precision: 10, scale: 2
      t.decimal :max_value, precision: 10, scale: 2
      t.integer :position

      t.timestamps
    end
  end
end
