class Wiki < ActiveRecord::Base
  belongs_to :user

  has_many :collaborators
  has_many :users, through: :collaborators

  # By default order by updated_at
  default_scope { order('updated_at DESC') }

#TODO Ask Alejandro
  scope :visible_to, -> (user) {
    if user
      if user.admin?
        Wiki.all
      else
        # Convert the array into an ActiveRecord::Relation
        wikis_array = (where(user: user) + publicly_viewable).uniq
        Wiki.where( id: wikis_array.map(&:id) )
      end
    else
      publicly_viewable
    end
  }

  scope :publicly_viewable,  -> { where(private: false) }
  scope :privately_viewable, -> { where(private: true)  }

  def public?
    !private
  end

  def private?
    !public?
  end

  def is_collaborator?(user)
    collaborators.each do |collab|
      if collab.user_id == user.id
        return true
      end
    end
    false
  end

  def has_collaborators?
    collaborators.count > 0
  end
end
