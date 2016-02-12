class CreateBuilders < ActiveRecord::Migration
  def change
    create_table :builders do |t|
      t.string :host
      t.integer :port

      t.timestamps null: false
    end
  end
end
