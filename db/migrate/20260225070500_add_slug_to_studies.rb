class AddSlugToStudies < ActiveRecord::Migration[7.1]
  class MigrationStudy < ActiveRecord::Base
    self.table_name = "studies"
  end

  def up
    add_column :studies, :slug, :string

    MigrationStudy.reset_column_information
    MigrationStudy.find_each do |study|
      base = study.title.to_s.parameterize.presence || "study"
      slug = base
      counter = 2

      while MigrationStudy.where(slug: slug).where.not(id: study.id).exists?
        slug = "#{base}-#{counter}"
        counter += 1
      end

      study.update_columns(slug: slug)
    end

    change_column_null :studies, :slug, false
    add_index :studies, :slug, unique: true
  end

  def down
    remove_index :studies, :slug
    remove_column :studies, :slug
  end
end
