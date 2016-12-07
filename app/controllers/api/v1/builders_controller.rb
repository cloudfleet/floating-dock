class Api::V1::BuildersController < ApiController


  def create
    if params[:key] == Rails.configuration.x.marina.new_builder_key
      @builder = Builder.new
      @builder.auth_key = (0..16).map { ('a'..'z').to_a[rand(26)] }.join
      @builder.save!
      render json: @builder
    else
      render text: "Access Denied", status: :unauthorized
    end
  end

  def request_build
    @builder = builder.find(params[:id])
    if request.headers["X-FLOATING-DOCK-BUILDER-KEY"] == @builder.auth_key
      @build = Build.request_build
      build_info = {
        build: {
          id: @build.id,
          repository_url: @build.repository.source_code_url,
          repository_branch: @build.repository_tag.reference,
          docker_file_path: @build.repository_tag.docker_file_path,
          image_name: "#{@build.repository.owner_name}/#{@build.repository.name}"
        },
        registry: {
          host: Rails.configuration.x.marina.docker_registry_host,
          user: Rails.configuration.x.marina.docker_registry_user,
          password: Rails.configuration.x.marina.docker_registry_password,
          email: Rails.configuration.x.marina.docker_registry_email
        }
      }
      render json: build_info
    else
      render text: "Access Denied", status: :unauthorized
    end
  end

  def update_build
    @builder = builder.find(params[:id])
    if request.headers["X-FLOATING-DOCK-BUILDER-KEY"] == @builder.auth_key
      @build = Build.find(params[:build_id])

      @build.status = params[:status]
      if params[:stdout]
        @build.stdout = params[:stdout]
      end
      if params[:stderr]
        @build.stderr = params[:stderr]
      end

      render json: build_info
    else
      render text: "Access Denied", status: :unauthorized
    end
  end

  def get_scripts

    prefix = 'scripts'
    suffix = '.tar.gz'
    f = Tempfile.new [prefix, suffix], Rails.root.join('tmp')

    Minitar.pack(Rails.root.join('lib/assets/marina/scripts'), Zlib::GzipWriter.new(File.open(f, 'wb'))

    send_file f
  end

end
