class Wiki < ActiveRecord::Base
  belongs_to :user

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

  scope :privately_viewable_for_user, -> (user) {
    where("user = ? AND private = ?", user, true)
  }

  scope :publicly_viewable,  -> { where(private: false) }
  scope :privately_viewable, -> { where(private: true)  }
end
