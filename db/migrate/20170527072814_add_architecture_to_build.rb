class AddArchitectureToBuild < ActiveRecord::Migration
  def change
    add_column :builds, :architecture, :string
  end
end
