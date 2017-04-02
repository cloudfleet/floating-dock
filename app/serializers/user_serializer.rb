class UserSerializer < ActiveModel::Serializer
  attributes :name, :id, :organizations

  def organizations
    object.organization_users.map do |ou|
      {role: ou.role, name: ou.organization.name, id: ou.organization.id}
    end
  end

end
