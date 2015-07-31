class CollaboratorsController < ApplicationController
  def new
    @collaborator = Collaborator.new
    @users = User.all
  end

  def create
    find_wiki
    @collaborator = Collaborator.new(wiki_id: params[:wiki_id], user_id: params[:user_id])

    if @collaborator.save
      redirect_to edit_wiki_path(@wiki)
    else
      flash[:error] = "Could not add #{@collaborator.user.name} as a collaborator. Please try again."
    end
  end

  def edit
    @users = User.all
  end

  def destroy
    find_wiki
    find_collaborator

    if @collaborator.destroy
      redirect_to edit_wiki_path(@wiki)
    else
      flash[:error] = "Unable to remove #{@collaborator.user.name} as a collaborator."
    end
  end

private

  def find_collaborator
    @collaborator = @wiki.collaborators.find_by(current_user.id)
  end

  def find_wiki
    @wiki = Wiki.find(params[:wiki_id])
  end
end
