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
        (where(user: user) + publicly_viewable).uniq
      end
    else
      publicly_viewable
    end
  }

  scope :publicly_viewable,  -> { where(private: false) }
  scope :privately_viewable, -> { where(private: true)  }
end
