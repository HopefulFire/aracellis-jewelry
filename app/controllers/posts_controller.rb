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
    if !@user
      @message = 'You must log in to submit a post'
      @link = '/users/login'
      erb :"/status/failure.html"
    elsif !@user.is_admin
      @message = 'You need to be an admin to submit a post'
      @link = "/users/#{@user.id}"
      erb :"/status/failure.html"
    else
      erb :"/posts/new.html"
    end
  end

  # POST: /posts
  post '/posts' do
    @user = User.find_by(id: session[:user_id])
    @post = Post.new
    @post.title = params[:title]
    @post.body = params[:body]
    @post.user = @user
    if !@user
      @message = 'You must log in to submit a post'
      @link = '/users/login'
      erb :"/status/failure.html"
    elsif !@user.is_admin
      @message = 'You need to be an admin to submit a post'
      @link = "/users/#{@user.id}"
      erb :"/status/failure.html"
    elsif !@post.save
      @message = "#{@post.errors.messages.keys.first}: #{@post.errors.messages.values.first.first}"
      @link = '/posts/new'
      erb :"/status/failure.html"
    else
      @message = 'Successfully created your post!'
      @link = "/posts/#{@post.id}"
      erb :"/status/success.html"
    end
  end

  # GET: /posts/5
  get '/posts/:id' do
    @user = User.find_by(id: session[:user_id])
    @post = Post.find_by(id: params[:id])
    @images = @post.images.reverse
    @comments = @post.comments.reverse
    erb :"/posts/show.html"
  end

  # GET: /posts/5/edit
  get '/posts/:id/edit' do
    @user = User.find_by(id: session[:user_id])
    @post = Post.find_by(id: params[:id])
    @images = @post.images.reverse
    @comments = @post.comments.reverse
    if !@user
      @message = 'You need to log in to edit a post'
      @link = '/users/login'
      erb :"/status/failure.html"
    elsif !@user.is_admin
      @message = 'You need to be an admin to edit a post'
      @link = "/users/#{@user.id}"
      erb :"/status/failure.html"
    elsif !@post
      @message = 'That post does not exist'
      @link = '/posts'
      erb :"/status/failure.html"
    else
      erb :"/posts/edit.html"
    end
  end

  # PATCH: /posts/5
  patch '/posts/:id' do
    @user = User.find_by(id: session[:user_id])
    @post = Post.find_by(id: params[:id])
    @post.title = params[:title]
    @post.body = params[:body]
    if !@user
      @message = 'You need to log in to edit a post'
      @link = '/users/login'
      erb :"/status/failure.html"
    elsif !@user.is_admin
      @message = 'You need to be an admin to edit a post'
      @link = "/users/#{@user.id}"
      erb :"/status/failure.html"
    elsif !@post
      @message = 'That post does not exist'
      @link = '/posts'
      erb :"/status/failure.html"
    elsif !@post.save
      @message = "#{@post.errors.messages.keys.first}: #{@post.errors.messages.values.first.first}"
      @link = "/posts/#{@post.id}/edit"
      erb :"/status/failure.html"
    else
      @message = "#{@post.title} by #{@post.user.username} was successfully edited"
      @link = "/posts/#{@post.id}"
      erb :"/status/success.html"
    end
  end

  get '/posts/:id/delete' do
    @user = User.find_by(id: session[:user_id])
    @post = Post.find_by(id: params[:id])
    if !@user
      @message = 'You need to log in to delete a post'
      @link = '/users/login'
      erb :"/status/failure.html"
    elsif !@user.is_admin
      @message = 'You need to be an admin to delete a post'
      @link = "/users/#{@user.id}"
      erb :"/status/failure.html"
    elsif !@post
      @message = 'That post does not exist'
      @link = '/posts'
      erb :"/status/failure.html"
    else
      erb :"/posts/delete.html"
    end
  end

  # DELETE: /posts/5
  delete '/posts/:id' do
    @user = User.find_by(id: session[:user_id])
    @post = Post.find_by(id: params[:id])
    if !@user
      @message = 'You need to log in to delete a post'
      @link = '/users/login'
      erb :"/status/failure.html"
    elsif !@user.is_admin
      @message = 'You need to be an admin to delete a post'
      @link = "/users/#{@user.id}"
      erb :"/status/failure.html"
    elsif !@post
      @message = 'That post does not exist'
      @link = '/posts'
      erb :"/status/failure.html"
    else
      @post.destroy
      @message = "#{@post.title} by #{@post.user.username} was successfully deleted"
      @link = '/posts'
      erb :"/status/success.html"
    end
  end
end
