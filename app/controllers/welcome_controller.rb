class WelcomeController < ApplicationController

  def show
    if user_signed_in?
      @user  = current_user
      @wikis = @user.wikis
      # authorize @wikis
      redirect_to wikis_path
    else
      redirect_to hello_path
    end
  end

end
