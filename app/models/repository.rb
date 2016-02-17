class Repository < ActiveRecord::Base
  has_many :repository_tags
  has_many :builds, through: :repository_tags
end
