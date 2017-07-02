class Repository < ActiveRecord::Base
  include PgSearch
  
  has_many :repository_tags
  has_many :builds, through: :repository_tags

  multisearchable :against => [:name, :owner_name]

  accepts_nested_attributes_for :repository_tags, allow_destroy: true

  def self.find_by_full_path(full_path)
    owner_name, name = full_path.split('/', 2)
    Repository.find_by(owner_name: owner_name, name: name)
  end
end
