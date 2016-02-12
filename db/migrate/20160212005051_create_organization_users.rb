class CreateOrganizationUsers < ActiveRecord::Migration
  def change
    create_table :organization_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :organisation, index: true, foreign_key: true
      t.string :role

      t.timestamps null: false
    end
  end
end
