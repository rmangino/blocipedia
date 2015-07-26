class User < ActiveRecord::Base
  enum role: [:free, :premium, :admin]
  after_initialize :set_default_role, :if => :new_record?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Delete a user's wikis if they delete their account
  has_many :wikis, dependent: :destroy

  def can_create_private_wikis?
    admin? || premium?
  end

private

  def set_default_role
    self.role ||= :free
  end
end
