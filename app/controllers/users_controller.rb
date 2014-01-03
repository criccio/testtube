class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @user }
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User settings were successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

end
