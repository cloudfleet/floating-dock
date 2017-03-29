class Build < ActiveRecord::Base
  belongs_to :repository_tag
  belongs_to :builder

  delegate :repository, to: :repository_tag

  def self.reserve(builder)
    all.detect do |build|
      count = where(builder_id: nil).where(id: build.id).update_all(builder_id: builder.id, state: 'assigned')
      count == 1 && build.reload
    end
  end



  private


end
