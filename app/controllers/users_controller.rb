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
    user = User.new
    user.username = params[:username]
    user.email_address = params[:email_address]
    user.password = params[:password]
    user.is_admin = params[:is_admin] == 'on'
    if user.save
      session[:user_id] = user.id
      redirect '/'
    end
  end

  # GET: /users/5
  get '/users/:id' do
    erb :"/users/show.html"
  end

  # GET: /users/5/edit
  get '/users/:id/edit' do
    erb :"/users/edit.html"
  end

  # PATCH: /users/5
  patch '/users/:id' do
    redirect '/users/:id'
  end

  # DELETE: /users/5/delete
  delete '/users/:id/delete' do
    redirect '/users'
  end
end
