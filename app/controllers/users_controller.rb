class UsersController < ApplicationController
  # GET: /users
  get '/users' do
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
      session[:user_id] = @user.id
      redirect '/'
    else
      redirect '/users/new'
    end
  end

  # GET: /users/5
  get '/users/:id' do
    @user = User.find_by(id: params[:id])
    erb :"/users/show.html" if @user
  end

  # GET: /users/5/edit
  get '/users/:id/edit' do
    @user = User.find_by(id: params[:id])
    erb :"/users/edit.html" if @user
  end

  # PATCH: /users/5
  patch '/users/:id' do
    @user = User.find_by(id: params[:id])
    @user.username = params[:username]
    @user.email_address = params[:email_address]
    @user.password = params[:password]
    if @user.id == session[:user_id] && @user.save
      redirect '/users/:id'
    else
      redirect '/users/:id/edit'
    end
  end

  # DELETE: /users/5/delete
  delete '/users/:id/delete' do
    redirect '/users'
  end
end
