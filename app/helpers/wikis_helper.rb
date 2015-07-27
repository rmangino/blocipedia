module WikisHelper

  def user_can_set_wiki_privacy?(user, wiki)
    (user && user.can_create_private_wikis?) || user.admin?
  end

end
