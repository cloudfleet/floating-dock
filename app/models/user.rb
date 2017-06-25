class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  validates :name, uniqueness: true
  validates :name, format: { with: /\A[a-z]+\z/ }
  validate :uniqueness_of_name_with_organization

  def uniqueness_of_name_with_organization
    if Organization.find_by(name: self.name)
      errors.add(:name, "exists already as organization")
    end
  end

  delegate :can?, :cannot?, :to => :ability

  has_many :organization_users
  has_many :organizations, through: :organization_users

  def repositories
    Repository.find_by(owner_name: self.name)
  end



  def available_namespaces
    [self.name] + organization_users.where(role: :admin).map{|ou| Organization.find(ou.organization_id).name}
  end

  def ability
    @ability ||= Ability.new(self)
  end

end
