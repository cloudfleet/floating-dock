class Builder < ActiveRecord::Base
  has_many :builds
  has_one :build, as: :current_build

  def can?(action, object)
    [:update, :read].include?(action) && object.is_a?(Repository)
  end
end
