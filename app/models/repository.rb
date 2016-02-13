class Repository < ActiveRecord::Base
  has_many :repository_tags
end
