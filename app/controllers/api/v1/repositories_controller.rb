class Api::V1::RepositoriesController < ApiController

  before_action :set_repository, only: [:show, :edit, :update, :build]

  def index
    if params[:namespace]
      @repositories = Repository.where(owner_name: params[:namespace])
    else
      @repositories = Repository.all
    end
    render json: @repositories
  end


  def show
    render json: @repository
  end

  def create
    authenticate_repository_write @repository, params
    Repository.create(repository_params)
    render json: @repository
  end

  def update
    authenticate_repository_write @repository, params
    @repository.update(repository_params)
    render json: @repository
  end

  def build
    authenticate_repository_write @repository, params

    @build = @repository.repository_tags.find(params[:tag_id]).build!
    render json: @build

  end

  def set_repository
    @repository = Repository.find_by(owner_name: params[:namespace], name: params[:name])
  end

  def repository_params
    params[:repository_tags_attributes] = params[:repository_tags]

    params.permit(
      :name,
      :owner_name,
      :source_code_url,
      :public,
      repository_tags_attributes: [
        :id,
        :_destroy,
        :name,
        :reference,
        :docker_file_path,
        :additional_tags
      ]
    )
  end

  def authenticate_repository_write(repository, params)
    # on creation repository is nil
    (
      (repository && current_api_v1_user.available_namespaces.include?(repository.owner_name)) \
      || \
      current_api_v1_user.available_namespaces.include?(params[:owner_name]) \
    )
  end

end
