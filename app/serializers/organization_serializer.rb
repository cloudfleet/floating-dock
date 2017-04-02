class OrganizationSerializer < ActiveModel::Serializer
  attributes :name, :api_key, :id, :members

  def members
    object.organization_users.map do |ou|
      {role: ou.role, name: ou.user.name, id: ou.user.id}
    end
  end

end
