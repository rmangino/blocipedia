class User < ActiveRecord::Base
  enum role: [:free, :premium, :admin]
  after_initialize :set_default_role, :if => :new_record?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Delete a user's wikis if they delete their account
  has_many :wikis, dependent: :destroy

  has_many :collaborators, through: :wikis

  def can_create_private_wikis?
    admin? || premium?
  end

  def can_upgrade_to_premium_account?
    free?
  end

  def can_downgrade_to_free_account?
    premium?
  end

  def upgrade_to_premium!
    premium!
  end

  def downgrade_to_free!
    free!
  end

  def can_be_collaborator?(wiki)
    wiki.user != self
  end


private

  def set_default_role
    self.role ||= :free
  end
end
