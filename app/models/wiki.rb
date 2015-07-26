class Wiki < ActiveRecord::Base
  belongs_to :user
  after_initialize :set_default_visibility, :if => :new_record?

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

private

  def set_default_visibility
    self.private ||= false
  end
end
