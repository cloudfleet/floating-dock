class OrganizationSerializer < ActiveModel::Serializer
  attributes :name, :api_key, :id, :members, :api_key

  def members
    object.organization_users.map do |ou|
      {role: ou.role, name: ou.user.name, id: ou.user.id}
    end
  end

  def filter(keys)
    if scope && scope.can?(:manage, object)
      keys
    else
      keys - [:api_key]
    end
  end

end
