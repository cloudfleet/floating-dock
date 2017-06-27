class Organization < ActiveRecord::Base
  has_many :organization_users
  has_many :users, through: :organization_users

  validates :name, uniqueness: true
  validates :name, format: { with: /\A[a-z]+\z/ }
  validate :uniqueness_of_name_with_user

  def uniqueness_of_name_with_user
    if User.find_by(name: self.name)
      errors.add(:name, "exists already as user")
    end
  end

  def repositories
    Repository.find_by(owner_name: self.name)
  end

end
