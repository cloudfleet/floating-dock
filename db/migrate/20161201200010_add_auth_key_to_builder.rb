class AddAuthKeyToBuilder < ActiveRecord::Migration
  def change
    add_column :builders, :auth_key, :string
  end
end
