class CommentsController < ApplicationController
  # GET: /comments
  get '/comments' do
    @user = User.find_by(session[:user_id])
    erb :"/comments/index.html"
  end

  # GET: /comments/new
  get '/comments/new' do
    @user = User.find_by(session[:user_id])
    erb :"/comments/new.html"
  end

  # POST: /comments
  post '/comments' do
    redirect '/comments'
  end

  # GET: /comments/5
  get '/comments/:id' do
    @user = User.find_by(session[:user_id])
    erb :"/comments/show.html"
  end

  # GET: /comments/5/edit
  get '/comments/:id/edit' do
    @user = User.find_by(session[:user_id])
    erb :"/comments/edit.html"
  end

  # PATCH: /comments/5
  patch '/comments/:id' do
    redirect '/comments/:id'
  end

  # DELETE: /comments/5/delete
  delete '/comments/:id/delete' do
    redirect '/comments'
  end
end
