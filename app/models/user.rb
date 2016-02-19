class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :organization_users
  has_and_belongs_to_many :organizations, through: :organization_users

  def repositories
    Repository.find_by(owner_name: self.name)
  end

end
