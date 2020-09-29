class PostsController < ApplicationController
  # GET: /posts
  get '/posts' do
    erb :"/posts/index.html" # done
  end

  # GET: /posts/new
  get '/posts/new' do
    erb :"/posts/new.html"
  end

  # POST: /posts
  post '/posts' do
    @user = User.find_by(id: session[:user_id])
    if @user
      @post = Post.new
      @post.title = params[:title]
      @post.body = params[:body]
      @post.user = @user
      if @post.save
        redirect '/posts'
      else
        redirect '/posts/new'
      end
    else
      redirect '/users/login'
    end
  end

  # GET: /posts/5 
  get '/posts/:id' do
    @post = Post.find_by(id: params[:id])
    @user = User.find_by(id: session[:user_id])
    if @post
      erb :"/posts/show.html"
    else
      redirect '/posts'
    end
  end

  # GET: /posts/5/edit
  get '/posts/:id/edit' do
    @post = Post.find_by(id: params[:id])
    erb :"/posts/edit.html" if @post
  end

  # PATCH: /posts/5
  patch '/posts/:id' do
    @post = Post.find_by(id: params[:id])
    @user = User.find_by(id: session[:user_id])
    if @user == @post.user || @user&.is_admin
      @post.title = params[:title]
      @post.body = params[:body]
      @post.save
    end
    redirect '/posts/:id'
  end

  # DELETE: /posts/5/delete
  delete '/posts/:id' do
    @post = Post.find_by(id: params[:id])
    @user = User.find_by(id: session[:id])
    @post.destroy if @user == @comment&.user || @user&.is_admin
    redirect '/posts'
  end
end
