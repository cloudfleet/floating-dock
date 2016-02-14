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
end
