class RepositoryTag < ActiveRecord::Base
  belongs_to :repository
  has_many :builds

  def last_build
    builds.order(:end).last
  end

  def build!
    ['armhf', 'aarch64'].each do |architecture|
      Build.create(repository_tag: self, start: DateTime.current, state: 'created', architecture: architecture)
    end
  end
end
