class UsersController < ApplicationController
  ##### USER AUTHENTICATION #####
  get '/users/login' do
    erb :"/users/login.html"
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
    erb :"/users/logout.html"
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
    @users = User.all.reverse
    erb :"/users/index.html"
  end

  # GET: /users/new
  get '/users/new' do
    erb :"/users/new.html"
  end

  # POST: /users
  post '/users' do
    @user = User.new
    @user.username = params[:username]
    @user.email_address = params[:email_address]
    @user.password = params[:password]
    @user.is_admin = false
    if @user.save
      @message = "You have successfully created an account for #{@user.username}"
      @link = '/users/login'
      erb :"/status/success.html"
    else
      @message = "#{@user.errors.messages.keys.first}: #{@user.errors.messages.values.first.first}"
      @link = '/users/new'
      erb :"/status/failure.html"
    end
  end

  # GET: /users/5
  get '/users/:id' do
    @user = User.find_by(id: params[:id])
    if @user
      @posts = @user.posts.reverse[0..10]
      @comments = @user.comments.reverse[0..10]
      erb :"/users/show.html"
    else
      @message = "The user with id #{params[:id]} does not exist"
      @link = '/users'
      erb :"/status/failure.html"
    end
  end

  # GET: /users/5/edit
  get '/users/:id/edit/:field' do
    @user = User.find_by(id: params[:id])
    @field = params[:field]
    if @user
      erb :"/users/edit.html"
    else
      @message = "The user with id #{params[:id]} does not exist"
      @link = '/users'
      erb :"/status/failure.html"
    end
  end

  # PATCH: /users/5
  patch '/users/:id' do
    @user = User.find_by(id: params[:id])
    if @user
      @user.username = params[:username] if params[:username]
      @user.email_address = params[:email_address] if params[:email_address]
      @user.password = params[:password] if params[:password]
      if @user.save
        @message = "#{@user.username} successfully changed"
        @link = '/users/home'
        erb :"/status/success.html"
      else
        @message = "#{@user.errors.messages.keys.first}: #{@user.errors.messages.values.first.first}"
        @link = "/users/#{@user.id}/edit"
        erb :"/status/failure.html"
      end
    else
      @message = "The user with id #{params[:id]} does not exist"
      @link = '/users'
      erb :"/status/failure.html"
    end
  end

  # DELETE: /users/5
  delete '/users/:id' do
    @user = User.find_by(id: params[:id])
    if @user
      @user.destroy
      @message = "#{@user.username} was deleted"
      @link = '/users'
      erb :"/status/success.html"
    else
      @message = "The user with id #{params[:id]} does not exist"
      @link = '/users'
      erb :"/status/failure.html"
    end
  end
end
