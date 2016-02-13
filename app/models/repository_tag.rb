class RepositoryTag < ActiveRecord::Base
  belongs_to :repository
  has_many :builds
end
