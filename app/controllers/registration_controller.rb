class RegistrationController < ApplicationController
  def new
    @account = Account.new
    @user = User.new
  end
  
  def create
    @user, @account = User.register(params['account'].delete('certify_user'), params['account'], request.host)

    # if we managed to save both records
    # (@user should fail to save if @account fails to save anyway)
    unless @user.new_record? || @account.new_record?
      flash[:notice] = t('certify.flash.register')
      redirect_to params[:return] ? params[:return] : login_url
    # if we failed to save
    else
      render :action => 'new'
    end
  end
end
