class UsersController < ApplicationController
  before_filter :save_login_state, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      flash[:notice] = "Hello, #{@user.username}! You signed up successfully!"
      redirect_to(:action => 'login', :controller => 'sessions')
    else
      flash[:notice] = "Form is invalid"
      render 'new'
    end
  end
end
