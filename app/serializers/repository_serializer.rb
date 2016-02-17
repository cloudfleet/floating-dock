class RepositorySerializer < ActiveModel::Serializer
  Repository.column_names.each {|pcn| attributes pcn}

  has_many :builds, through: :repository_tags
end
