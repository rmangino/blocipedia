class WikiPolicy < ApplicationPolicy

  # Anyone, even non-logged in users, can view public wikis
  def index?
    true
  end

  def update?
    # A user has to be present. Any user can edit any wiki that
    # are publicly viewable. Admins can edit *all* wikis
    return false if !user.present?

    if record.private?
      return record.user == user || user.admin?
    end

    true
  end

  def edit?
    update?
  end


  def destroy?
    user.present? && (record.user == user || user.admin?)
  end

end