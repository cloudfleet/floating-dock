class Build < ActiveRecord::Base
  belongs_to :repository_tag
  belongs_to :builder

  delegate :repository, to: :repository_tag

  def execute
    puts "Executing build #{id}"
    logger.info "Executing build #{id}"

    assign_to_builder

    self.state = execute_on_build_machine ? 'success' : 'failure'
    save!

    self.builder.release
  end

  private

  def assign_to_builder
    while true do
      self.builder = ::Builder.reserve self
      if self.builder
        break
      end
      sleep 10
    end
    self.state = 'assigned'
    save!

  end

  def execute_on_build_machine

    success = false

    begin
      bbox = Rye::Box.new(self.builder.host, {user: 'root'} )

      Rye::Cmd.add_command :build_and_push, 'marina/scripts/build_and_push_docker_image.sh'

      result = bbox.build_and_push(
        repository.source_code_url,
        repository_tag.reference,
        repository_tag.docker_file_path,
        "#{repository.owner_name}/#{repository.name}",
        Rails.configuration.x.marina.docker_registry_host,
        Rails.configuration.x.marina.docker_registry_user,
        Rails.configuration.x.marina.docker_registry_password,
        Rails.configuration.x.marina.docker_registry_email
      )
      self.std_out = result.stdout
      self.std_err = result.stderr
      save!
      success = result.exit_status == 0
    rescue => e
      puts e
    end
    success
  end

  def handle_build_fail
    # Do something, like sending emails
  end

end
