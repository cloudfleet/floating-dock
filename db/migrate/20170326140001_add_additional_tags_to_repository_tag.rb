class AddAdditionalTagsToRepositoryTag < ActiveRecord::Migration
  def change
    add_column :repository_tags, :additional_tags, :string, default: ''
  end
end
