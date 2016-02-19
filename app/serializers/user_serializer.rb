class UserSerializer < ActiveModel::Serializer
  attributes :name, :organizations

  def organizations
    object.organization_users.map do |ou|
      {role: ou.role, name: ou.organization.name}
    end
  end

  class OrganizationUserSerializer < ActiveModel::Serializer
    attributes :name, :role
    def name
      object.organization.name
    end
  end
end
