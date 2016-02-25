class Api::V1::OrganizationsController < ApiController

  load_and_authorize_resource

  def show
    render json: @organization
  end

  def show_api_key
    render json: {api_key: @organization.api_key}
  end

  def generate_api_key
    @organization.api_key =  (0..32).map { ('a'..'z').to_a[rand(26)] }.join
    @organization.save!
    render json: {result: 'success'}
  end

  def update
    @organization.update(organization_params)
    render json: @organization
  end

  def create
    Organization.transaction do
      @organization = Organization.create(organization_params)
      @organization_user = OrganizationUser.create(user: current_api_v1_user, organization: @organization, role: :admin)
    end
    render json: @organization
  end

  def organization_params
    params.permit(:name)
  end

end
