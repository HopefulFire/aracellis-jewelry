class CommentsController < ApplicationController
  # GET: /comments
  get '/comments' do
    @user = User.find_by(id: session[:user_id])
    @comments = Comments.all.reverse
    erb :"/comments/index.html"
  end

  # GET: /comments/new
  get '/comments/new/:post_id' do
    @user = User.find_by(id: session[:user_id])
    @post = Post.find_by(id: params[:post_id])
    if !@user
      @message = 'You need to be logged in'
      @link = '/users/login'
      erb :"/status/failure.html"
    elsif !@post
      @message = 'That post does not exist'
      @link = '/posts'
      erb :"/status/failure.html"
    else
      erb :"/comments/new.html"
    end
  end

  # POST: /comments
  post '/comments/:post_id' do
    @user = User.find_by(id: session[:user_id])
    @post = Post.find_by(id: params[:id])
    if !@user
      @message = 'You need to be logged in'
      @link = '/users/login'
      erb :"/status/failure.html"
    elsif !@post
      @message = 'That post does not exist'
      @link = '/posts'
      erb :"/status/failure.html"
    else
      @comment = Comment.new
      @comment.body = params[:body]
      @comment.user = @user
      @comment.post = @post
      if !@comment.save
        @message = "#{@comment.errors.messages.keys.first}: #{@comment.errors.messages.values.first.first}"
        @link = "/comment/new/#{@post.id}"
        erb :"/status/failure.html"
      else
        @message = 'Successfully saved your comment'
        @link = "/comments/#{comment.id}"
        erb :"/status/success.html"
      end
    end
  end

  # GET: /comments/5
  get '/comments/:id' do
    @user = User.find_by(id: session[:user_id])
    erb :"/comments/show.html"
  end

  # GET: /comments/5/edit
  get '/comments/:id/edit' do
    @user = User.find_by(id: session[:user_id])
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
