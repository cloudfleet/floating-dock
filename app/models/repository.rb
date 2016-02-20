class Repository < ActiveRecord::Base
  has_many :repository_tags
  has_many :builds, through: :repository_tags

  accepts_nested_attributes_for :repository_tags, allow_destroy: true
end
