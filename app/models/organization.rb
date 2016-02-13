class Organization < ActiveRecord::Base


  def repositories
    Repository.find_by(owner_name: self.name)
  end
    
end
