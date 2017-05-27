class AddArchitectureToBuilder < ActiveRecord::Migration
  def change
    add_column :builders, :architecture, :string
  end
end
