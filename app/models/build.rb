class Build < ActiveRecord::Base
  belongs_to :repository_tag
  belongs_to :builder

  def execute
    puts "Executing build #{id}"
    logger.info "Executing build #{id}"
    while true do
      self.builder = ::Builder.reserve self
      if self.builder
        break
      end
      sleep 10
    end
    self.state = 'assigned'
    save!

    self.state = 'success'
    save!
    self.builder.release
  end
end
