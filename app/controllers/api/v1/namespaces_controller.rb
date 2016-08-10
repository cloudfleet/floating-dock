class Api::V1::OrganizationsController < ApiController

  def show
    resource = namespace_resource
    render json: {
      type: resource.class.name.downcase,
      id: resource.id,
      name: resource.name
    }
  end

  def namespace_resource
    name = params[:name]
    User.find_by(name: name) || Organization.find_by(name: name)
  end

end
