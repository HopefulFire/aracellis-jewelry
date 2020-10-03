class UsersController < ApplicationController
  ##### USER AUTHENTICATION #####
  get '/users/login' do
    @user = User.find_by(id: session[:user_id])
    if @user
      @message = 'Hey, you are already logged in!'
      @link = '/'
      erb :"/status/failure.html"
    else
      erb :"/users/login.html"
    end
  end

  post '/users/login' do
    @user = User.find_by(username: params[:username])
    if !@user&.authenticate(params[:password])
      @message = 'Wrong password or username'
      @link = '/users/login'
      erb :"/status/failure.html"
    else
      session[:user_id] = @user.id
      @message = 'You have successfully logged in'
      @link = "/users/#{@user.id}"
      erb :"/status/success.html"
    end
  end

  get '/users/logout' do
    @user = User.find_by(id: session[:user_id])
    if !@user
      @message = 'Seriously? You are already anonymous!'
      @link = '/'
      erb :"/status/failure.html"
    else
      erb :"/users/logout.html"
    end
  end

  post '/users/logout' do
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
    if @user
      @message = 'Hey, you are already logged in!'
      @link = "/users/#{user.id}"
      erb :'/status/failure.html'
    else
      erb :"/users/new.html"
    end
  end

  # POST: /users
  post '/users' do
    @user = User.find_by(id: session[:id])
    @new_user = User.new
    @new_user.username = params[:username]
    @new_user.email_address = params[:email_address]
    @new_user.password = params[:password]
    @new_user.is_admin = false
    if @user
      @message = 'You are already logged in as a user!'
      @link = "/users/#{user.id}"
      erb :"/status/failure.html"
    elsif !@new_user.save
      @message = "#{@new_user.errors.messages.keys.first}: #{@new_user.errors.messages.values.first.first}"
      @link = '/users/new'
      erb :"/status/failure.html"
    else
      @message = "You have successfully created an account for #{@new_user.username}"
      @link = '/users/login'
      erb :"/status/success.html"
    end
  end

  # GET: /users/5
  get '/users/:id' do
    @user = User.find_by(id: session[:user_id])
    @show_user = User.find_by(id: params[:id])
    if !@show_user
      @message = "The user with id #{params[:id]} does not exist"
      @link = '/users'
      erb :"/status/failure.html"
    else
      @posts = @show_user.posts.reverse[0..10]
      @comments = @show_user.comments.reverse[0..10]
      erb :"/users/show.html"
    end
  end

  # GET: /users/5/edit
  get '/users/:id/edit/:field' do
    @user = User.find_by(id: session[:user_id])
    @edit_user = User.find_by(id: params[:id])
    @field = params[:field]
    if !@edit_user
      @message = "The user with id #{params[:id]} does not exist"
      @link = '/users'
      erb :"/status/failure.html"
    elsif @edit_user != @user && !@user&.is_admin
      @message = 'You do not have permission to edit this user'
      @link = '/users'
      erb :"/status/failure.html"
    else
      erb :"/users/edit.html"
    end
  end

  # PATCH: /users/5
  patch '/users/:id' do
    @user = User.find_by(id: session[:user_id])
    @edit_user = User.find_by(id: params[:id])
    @edit_user.username = params[:username] if params[:username]
    @edit_user.email_address = params[:email_address] if params[:email_address]
    @edit_user.password = params[:password] if params[:password]
    if !@edit_user
      @message = "The user with id #{params[:id]} does not exist"
      @link = '/users'
      erb :"/status/failure.html"
    elsif @edit_user != @user && !@user.is_admin
      @message = 'You do not have permission to edit this user'
      @link = '/users'
      erb :"/status/failure.html"
    elsif !@edit_user.save
      @message = "#{@edit_user.errors.messages.keys.first}: #{@edit_user.errors.messages.values.first.first}"
      @link = "/users/#{@edit_user.id}/edit"
      erb :"/status/failure.html"
    else
      @message = "#{@user.username} successfully changed"
      @link = "/users/#{@user.id}"
      erb :"/status/success.html"
    end
  end

  get '/users/:id/delete' do
    @user = User.find_by(id: session[:user_id])
    @delete_user = User.find_by(id: params[:id])
    if !@delete_user
      @message = "The user with id #{params[:id]} does not exist"
      @link = '/users'
      erb :"/status/failure.html"
    elsif @delete_user != @user && !@user.is_admin
      @message = 'You do not have permission to delete this user'
      @link = '/users'
      erb :"/status/failure.html"
    else
      erb :"/users/delete.html"
    end
  end

  # DELETE: /users/5
  delete '/users/:id' do
    @user = User.find_by(id: session[:user_id])
    @delete_user = User.find_by(id: params[:id])
    if !@delete_user
      @message = "The user with id #{params[:id]} does not exist"
      @link = '/users'
      erb :"/status/failure.html"
    elsif @delete_user != @user && !@user.is_admin
      @message = 'You do not have permission to delete this user'
      @link = '/users'
      erb :"/status/failure.html"
    else
      @delete_user.destroy
      @message = "#{@delete_user.username} was deleted"
      @link = '/users'
      erb :"/status/success.html"
    end
  end
end
