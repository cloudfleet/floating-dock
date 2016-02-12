class Build < ActiveRecord::Base
  belongs_to :repository_tag
  belongs_to :builder
end
