class WikisController < ApplicationController
  def index
    @wikis =  policy_scope(Wiki)
  end

  def show
    @wiki = find_wiki
    authorize @wiki
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    authorize @wiki

    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else
      flash[:error] = "There was an error saving the Wiki. Please try again."
      render :new
    end
  end

  def edit
    find_wiki
    authorize @wiki
  end

  def update
    params[:wiki][:collaborator_ids] ||= []

    find_wiki
    authorize @wiki
    if @wiki.update_attributes(wiki_params)
      flash[:notice] = "Wiki was updated."
      redirect_to @wiki
    else
      flash[:error] = "There was an error updating the Wiki. Please try again."
      render :edit
    end
  end

  def destroy
    find_wiki
    authorize @wiki

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to wikis_path
    else
      flash[:error] = "There was an error deleting the Wiki."
      render :show
    end
  end

  def update_collaborators
    params[:user_ids] ||= []
    find_wiki

    User.all.each do |user|
      if user.can_be_collaborator?(@wiki)
        if params[:user_ids].include?(user.id.to_s)
          if nil == Collaborator.find_by(user_id: user.id, wiki_id: @wiki.id)
            Collaborator.create!(user_id: user.id, wiki_id: @wiki.id)
          end
        else
          Collaborator.destroy_all(user_id: user.id, wiki_id: @wiki.id)
        end
      end
    end

    flash[:notice] = "Collaborators updated."
    redirect_to @wiki
  end

private

  def find_wiki
    @wiki = Wiki.find(params[:id])
  end

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
