class PostsController < ApplicationController
  # GET: /posts
  get '/posts' do
    @user = User.find_by(session[:user_id])
    @posts = Post.all.reverse
    erb :"/posts/index.html"
  end

  # GET: /posts/new
  get '/posts/new' do
    @user = User.find_by(session[:user_id])
    erb :"/posts/new.html"
  end

  # POST: /posts
  post '/posts' do
    redirect '/posts'
  end

  # GET: /posts/5
  get '/posts/:id' do
    @user = User.find_by(session[:user_id])
    erb :"/posts/show.html"
  end

  # GET: /posts/5/edit
  get '/posts/:id/edit' do
    @user = User.find_by(session[:user_id])
    erb :"/posts/edit.html"
  end

  # PATCH: /posts/5
  patch '/posts/:id' do
    redirect '/posts/:id'
  end

  # DELETE: /posts/5/delete
  delete '/posts/:id/delete' do
    redirect '/posts'
  end
end
