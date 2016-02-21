class RepositoryTag < ActiveRecord::Base
  belongs_to :repository
  has_many :builds

  def last_build
    builds.order(:end).last
  end
end
