class Builder < ActiveRecord::Base
  has_many :builds
  has_one :build, as: :current_build

  def self.reserve(build)
    all.detect do |builder|
      count = where(build_id: nil).where(id: builder.id).update_all(locked_at: DateTime.current, build_id: build.id)
      count == 1 && builder.reload
    end
  end

  def release
    self.locked_at = nil
    self.build_id = nil
    save!
  end

  def setup_scripts
    unless reachable?
      rye_box.dir_upload "lib/assets/marina", "."
    end
  end

  def update_scripts
    rye_box.rm
    setup_scripts
  end


  def reachable?
    begin
      scripts_version
      true
    rescue
      false
    end
  end

  def scripts_version
    YAML::load(rye_box.version.stdout.to_s)
  end

  def status
    {
      reachable: reachable?,
      scripts_version: scripts_version,
      busy: self.locked_at != nil
    }
  end

  def rye_box
    Rye::Box.new(self.builder.host, {user: 'root'}, :password_prompt => false )
  end
end
