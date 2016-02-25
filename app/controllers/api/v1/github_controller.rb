class Api::V1::GithubController < ApiController

  before_action :set_tag

  def push
    if @tag
      @build = Build.create(repository_tag: @tag, start: DateTime.current, state: 'created')
      @build.delay.execute
    else
      render json: '{"error": "not_found"}', status: :not_found
    end

  end


  def set_tag

    authorize_namespace!

    owner_name = params[:repository][:owner][:name]
    name = params[:repository][:name]
    @repository = Repository.find_by!(owner_name: owner_name, name: name)
    @tag = @repository.repository_tags.where(reference: params[:ref].split('/').last).first
  end

  def authorize_namespace!
    owner = User.find_by(name: params[:namespace]) || Organization.find_by(name: params[:namespace])
    unless owner.api_key == params[:api_key] && params[:namespace] == params[:repository][:owner][:name]
      CanCan::AccessDenied.new("Not authorized!", :push, Build)
    end
  end

end
