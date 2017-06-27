class Api::V1::GithubController < ApiController

  before_action :set_tag

  def push
    if @tag
      @tag.build!
    else
      render json: '{"error": "not_found"}', status: :not_found
    end

  end


  def set_tag
    authorize_namespace!

    owner_name = params[:namespace]
    @repository = Repository.find_by!(owner_name: owner_name, source_code_url: params[:repository][:clone_url])
    @tag = @repository.repository_tags.where(reference: params[:ref].split('/').last).first
  end

  def authorize_namespace!
    namespace = params[:namespace]
    owner = User.find_by(name: namespace) || Organization.find_by(name: namespace)
    unless owner && verify_signature(owner.api_key, request.raw_post)
      render text: 'forbidden', status: :forbidden
    end
  end

  def verify_signature(api_key, payload_body)
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), api_key, payload_body)
    Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end

end
