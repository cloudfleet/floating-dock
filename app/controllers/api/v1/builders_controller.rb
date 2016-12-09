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
    @builder = Builder.find(params[:id])
    if request.headers["X-FLOATING-DOCK-BUILDER-KEY"] == @builder.auth_key
      @build = Build.reserve @builder
      if @build
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
        render json: {}
      end
    else
      render text: "Access Denied", status: :unauthorized
    end
  end

  def update_build
    @builder = Builder.find(params[:id])
    if request.headers["X-FLOATING-DOCK-BUILDER-KEY"] == @builder.auth_key
      @build = Build.find(params[:build_id])

      @build.state = params[:status]
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
    send_data ActiveSupport::Gzip.compress(tar(Rails.root.join('lib/assets/marina/scripts')).string),
      :filename => 'scripts.tar.gz',
      :type => "application/gzip",
      :disposition => "attachment"

  end

  def tar(path)
    tarfile = StringIO.new("")
    Gem::Package::TarWriter.new(tarfile) do |tar|
      Dir[File.join(path, "**/*")].each do |file|
        mode = File.stat(file).mode
        relative_file = file.sub /^#{Regexp::escape path.to_s}\/?/, ''

        if File.directory?(file)
          tar.mkdir relative_file, mode
        else
          tar.add_file relative_file, mode do |tf|
            File.open(file, "rb") { |f| tf.write f.read }
          end
        end
      end
    end

    tarfile.rewind
    tarfile
  end
end
