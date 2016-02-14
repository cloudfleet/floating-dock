class Api::V1::GithubController < ApiController

  before_action :set_tag

  def push
    if @tag
      @build = Build.create(repository_tag: @tag, start: DateTime.current, state: 'created')
      @build.execute
    else
      render json: '{"error": "not_found"}', status: :not_found
    end

  end


  def set_tag
    owner_name = params[:repository][:owner][:name]
    name = params[:repository][:name]
    @repository = Repository.find_by!(owner_name: owner_name, name: name)
    @tag = @repository.repository_tags.where(reference: params[:ref]).first
  end

end
