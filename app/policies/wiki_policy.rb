class WikiPolicy < ApplicationPolicy

  # Anyone, even non-logged in users, can view public wikis
  def index?
    true
  end

  def update?
    # A user has to be present. Any user can edit all public wikis, private
    # wikis that they own, or private wikis that they are a collaborator.
    # Admins can edit *all* wikis.
    return false if !user.present?

    if record.private?
      collaborator = record.collaborators.find(user.id)
      return record.user == user || nil != collaborator || user.admin?
    end

    true
  end

  def edit?
    update?
  end


  def destroy?
    user.present? && (record.user == user || user.admin?)
  end

  #############################################################################

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      wikis = []
      return wikis if !user

      if user.admin?
        # Admins see everything
        wikis = scope.all
      elsif user.premium?
        # Premium users see: public wikis, private wikis they created,
        # private wikis they are a collaborator on
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if wiki.public? || wiki.user == user || wiki.users.include?(user)
            wikis << wiki
          end
        end
      else
        # This is a Free user. They can only see public wikis and private wikis
        # they are collaborators on.
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if wiki.public? || wiki.users.include?(user)
            wikis << wiki
          end
        end
      end

      wikis
    end

  end # class Scope

end