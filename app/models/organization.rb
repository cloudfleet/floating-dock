class Organization < ActiveRecord::Base
  has_many :organization_users
  has_many :users, through: :organization_users

  def repositories
    Repository.find_by(owner_name: self.name)
  end

end
