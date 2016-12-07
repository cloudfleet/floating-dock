class RemoveUnnecessaryPropertiesFromBuilder < ActiveRecord::Migration
  def change
    remove_column :builders, :host
    remove_column :builders, :port
    remove_column :builders, :locked_at
    remove_column :builders, :build_id
  end
end
