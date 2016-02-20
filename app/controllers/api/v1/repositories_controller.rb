class Api::V1::RepositoriesController < ApiController

  before_action :set_repository, only: [:show, :edit, :update]

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

  def update
    authenticate_repository_write @repository, params
    @repository.update(repository_params)
    render json: @repository
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
        :docker_file_path
      ]
    )
  end

  def authenticate_repository_write(repository, params)
    ([repository.owner_name, params[:owner_name]].uniq - current_api_v1_user.available_namespaces).empty?
    # means that both old and new owner name are accessible to the user
  end

end
