class RepositorySerializer < ActiveModel::Serializer
  Repository.column_names.each {|pcn| attributes pcn}

  has_many :repository_tags
  has_many :builds, through: :repository_tags
end
