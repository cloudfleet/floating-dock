class AddLockFieldsToBuilder < ActiveRecord::Migration
  def change
    add_column :builders, :locked_at, :timestamp
    add_reference :builders, :build, index: true, foreign_key: true
  end
end
