class UserSerializer < ActiveModel::Serializer
  attributes :name, :id, :organizations, :api_key

  def organizations
    object.organization_users.map do |ou|
      {role: ou.role, name: ou.organization.name, id: ou.organization.id}
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
