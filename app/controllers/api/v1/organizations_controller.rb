class Api::V1::OrganizationsController < ApiController

  load_and_authorize_resource

  def show
    render json: @organization
  end

  def update
    @organization.update(organization_params)
    render json: @organization
  end

  def create
    @organization = Organization.create(organization_params)
    @organization_user = OrganizationUser.create(user: current_user, orgaization: @organization, type: :admin)
    render json: @organization
  end

  def organization_params
    params.require(:name)
  end

end
