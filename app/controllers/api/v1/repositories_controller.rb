class Api::V1::RepositoriesController < ApiController

  before_action :set_repository, only: [:show, :edit]

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

  def set_repository
    @repository = Repository.find_by(owner_name: params[:namespace], name: params[:name])
  end

end
