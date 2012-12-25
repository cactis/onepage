# -*- encoding : utf-8 -*-
class AccountsController < Devise::RegistrationsController

  def show
    @user = User.find(params[:id])
    @books = @user.books.page(params[:page])
    @pages = @user.pages.page(params[:page])
  end

  def destroy
    logger.debug { "---------------- AccountController" }
    resource.soft_delete!
    sign_out_and_redirect("/login")
    set_flash_message :notice, :destroyed
  end
end
