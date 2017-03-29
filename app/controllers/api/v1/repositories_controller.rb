class Api::V1::RepositoriesController < ApiController

  before_action :set_repository, only: [:show]
  before_action :set_and_authenticate_repository, only: [:edit, :update, :build]
  before_action :authenticate_namespace, only: [:create]

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
    Repository.create(repository_params)
    render json: @repository
  end

  def update
    @repository.update(repository_params)
    render json: @repository
  end

  def build
    @build = @repository.repository_tags.find(params[:tag_id]).build!
    render json: @build

  end

  private

  def set_repository
    @repository = Repository.find_by(owner_name: params[:namespace], name: params[:name])
  end

  def set_and_authenticate_repository
    set_repository
    can?(current_user, :update, @repository)
  end

  def authenticate_namespace
    current_user.available_namespaces.include? params[:owner_name]
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


end
