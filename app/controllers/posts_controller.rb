class PostsController < ApplicationController
  # GET: /posts
  get '/posts' do
    @user = User.find_by(id: session[:user_id])
    @posts = Post.all.reverse
    erb :"/posts/index.html"
  end

  # GET: /posts/new
  get '/posts/new' do
    @user = User.find_by(id: session[:user_id])
    if @user&.is_admin
      erb :"/posts/new.html"
    else
      @message = 'You must log in as an admin to submit a post'
      @link = '/users/login'
      erb :"/status/failure.html"
    end
  end

  # POST: /posts
  post '/posts' do
    @user = User.find_by(id: session[:user_id])
    if @user&.is_admin
      @post = Post.new
      @post.title = params[:title]
      @post.body = params[:body]
      @post.user = @user
      if @post.save
        @message = 'Successfully created your post!'
        @link = "/posts/#{@post.id}"
        erb :"/status/success.html"
      else
        @message = "#{@posts.errors.messages.keys.first}: #{@posts.errors.messages.values.first.first}"
        @link = '/posts/new'
        erb :"/status/failure.html"
      end
    else
      @message = 'You must log in as an admin to submit a post'
      @link = '/users/login'
      erb :"/status/failure.html"
    end
  end

  # GET: /posts/5
  get '/posts/:id' do
    @user = User.find_by(id: session[:user_id])
    @post = Post.find_by(id: params[:id])
    @images = @post.images
    @comments = @post.comments
    erb :"/posts/show.html"
  end

  # GET: /posts/5/edit
  get '/posts/:id/edit' do
    @user = User.find_by(id: session[:user_id])
    erb :"/posts/edit.html"
  end

  # PATCH: /posts/5
  patch '/posts/:id' do
    redirect '/posts/:id'
  end

  get '/posts/:id/delete' do
  end

  # DELETE: /posts/5
  delete '/posts/:id' do
    redirect '/posts'
  end
end
