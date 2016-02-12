class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :owner_name
      t.string :name
      t.boolean :public
      t.string :source_code_url

      t.timestamps null: false
    end
  end
end
