class CreateRepositoryTags < ActiveRecord::Migration
  def change
    create_table :repository_tags do |t|
      t.references :repository, index: true, foreign_key: true
      t.string :name
      t.string :reference
      t.string :docker_file_path

      t.timestamps null: false
    end
  end
end
