class UsersController < ApplicationController
  ##### USER AUTHENTICATION #####
  get '/users/login' do
    @user = User.find_by(id: session[:user_id])
    if !@user
      erb :"/users/login.html"
    else
      @message = 'Hey, you are already logged in!'
      @link = '/'
      erb :"/status/failure.html"
    end
  end

  post '/users/login' do
    @user = User.find_by(username: params[:username])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      @message = 'You have successfully logged in'
      @link = "/users/#{@user.id}"
      erb :"/status/success.html"
    else
      @message = 'Wrong password or username'
      @link = '/users/login'
      erb :"/status/failure.html"
    end
  end

  get '/users/logout' do
    @user = User.find_by(id: session[:user_id])
    if @user
      erb :"/users/logout.html"
    else
      @message = 'Seriously? You are already anonymous!'
      @link = '/'
      erb :"/status/failure.html"
    end
  end

  post '/users/logout' do
    session[:user_id] = nil
    session.clear
    @message = 'Successfully logged you out'
    @link = '/'
    erb :"/status/success.html"
  end

  ##### USER CRUD #####
  # GET: /users
  get '/users' do
    @user = User.find_by(id: session[:user_id])
    @users = User.all.reverse
    erb :"/users/index.html"
  end

  # GET: /users/new
  get '/users/new' do
    @user = User.find_by(id: session[:user_id])
    if !@user
      erb :"/users/new.html"
    else
      @message = 'Hey, you are already logged in!'
      @link = "/users/#{user.id}"
      erb :'/status/failure.html'
    end
  end

  # POST: /users
  post '/users' do
    @user = User.find_by(id: session[:id])
    if !@user
      @new_user = User.new
      @new_user.username = params[:username]
      @new_user.email_address = params[:email_address]
      @new_user.password = params[:password]
      @new_user.is_admin = false
      if @new_user.save
        @message = "You have successfully created an account for #{@new_user.username}"
        @link = '/users/login'
        erb :"/status/success.html"
      else
        @message = "#{@new_user.errors.messages.keys.first}: #{@new_user.errors.messages.values.first.first}"
        @link = '/users/new'
        erb :"/status/failure.html"
      end
    else
      @message = 'You are already logged in as a user!'
      @link = "/users/#{user.id}"
      erb :"/status/failure.html"
    end
  end

  # GET: /users/5
  get '/users/:id' do
    @user = User.find_by(id: session[:user_id])
    @show_user = User.find_by(id: params[:id])
    if @show_user
      @posts = @show_user.posts.reverse[0..10]
      @comments = @show_user.comments.reverse[0..10]
      erb :"/users/show.html"
    else
      @message = "The user with id #{params[:id]} does not exist"
      @link = '/users'
      erb :"/status/failure.html"
    end
  end

  # GET: /users/5/edit
  get '/users/:id/edit/:field' do
    @user = User.find_by(id: session[:user_id])
    @edit_user = User.find_by(id: params[:id])
    @field = params[:field]
    if @edit_user == @user || @user&.is_admin
      erb :"/users/edit.html"
    else
      @message = "The user with id #{params[:id]} does not exist or you do not have permission to edit"
      @link = '/users'
      erb :"/status/failure.html"
    end
  end

  # PATCH: /users/5
  patch '/users/:id' do
    @user = User.find_by(id: session[:user_id])
    @edit_user = User.find_by(id: params[:id])
    if @edit_user == @user || @user.is_admin
      @edit_user.username = params[:username] if params[:username]
      @edit_user.email_address = params[:email_address] if params[:email_address]
      @edit_user.password = params[:password] if params[:password]
      if @edit_user.save
        @user = @edit_user
        @message = "#{@user.username} successfully changed"
        @link = "/users/#{@user.id}"
        erb :"/status/success.html"
      else
        @message = "#{@edit_user.errors.messages.keys.first}: #{@edit_user.errors.messages.values.first.first}"
        @link = "/users/#{@edit_user.id}/edit"
        erb :"/status/failure.html"
      end
    else
      @message = "The user with id #{params[:id]} does not exist or you do not have permission to edit"
      @link = '/users'
      erb :"/status/failure.html"
    end
  end

  get '/users/:id/delete' do
    @user = User.find_by(id: session[:user_id])
    @delete_user = User.find_by(id: params[:id])
    if @delete_user == @user || @user&.is_admin
      erb :"/users/delete.html"
    else
      @message = "The user with id #{params[:id]} does not exist or you do not have permission to delete"
      @link = '/users'
    end
  end

  # DELETE: /users/5
  delete '/users/:id' do
    @user = User.find_by(id: session[:user_id])
    @delete_user = User.find_by(id: params[:id])
    if @delete_user == @user || @user&.is_admin
      @delete_user.destroy
      @message = "#{@delete_user.username} was deleted"
      @link = '/users'
      erb :"/status/success.html"
    else
      @message = "The user with id #{params[:id]} does not exist or you do not have permission to delete"
      @link = '/users'
      erb :"/status/failure.html"
    end
  end
end
