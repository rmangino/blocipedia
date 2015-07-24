class WikisController < ApplicationController
  def index
    # @wikis =  Wiki.where( { user_id: current_user.id } )
    @wikis =  Wiki.all
    # authorize @wikis
  end

  def show
    # authorize @wiki
    @wiki = find_wiki
  end

  def new
    @wiki = Wiki.new
    # authorize @wiki
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    # authorize @wiki

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
    # authorize @wiki
  end

  def update
    find_wiki
    # authorize @wiki
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
    # authorize @wiki

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to wikis_path
    else
      flash[:error] = "There was an error deleting the Wiki."
      render :show
    end
  end

private

  def find_wiki
    @wiki = Wiki.find(params[:id])
  end

  def wiki_params
    params.require(:wiki).permit(:title, :body)
  end
end
