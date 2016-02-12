class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.references :repository_tag, index: true, foreign_key: true
      t.timestamp :start
      t.timestamp :end
      t.text :std_out
      t.text :std_err
      t.string :state
      t.references :builder, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
