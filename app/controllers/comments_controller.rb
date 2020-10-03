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
    @post = Post.find_by(id: params[:post_id])
    @comment = Comment.new
    @comment.body = params[:body]
    @comment.user = @user
    @comment.post = @post
    if !@user
      @message = 'You need to be logged in'
      @link = '/users/login'
      erb :"/status/failure.html"
    elsif !@post
      @message = 'That post does not exist'
      @link = '/posts'
      erb :"/status/failure.html"
    elsif !@comment.save
      @message = "#{@comment.errors.messages.keys.first}: #{@comment.errors.messages.values.first.first}"
      @link = "/comments/new/#{@post.id}"
      erb :"/status/failure.html"
    else
      @message = 'Successfully saved your comment'
      @link = "/comments/#{@comment.id}"
      erb :"/status/success.html"
    end
  end

  # GET: /comments/5
  get '/comments/:id' do
    @user = User.find_by(id: session[:user_id])
    @comment = Comment.find_by(id: params[:id])
    if !@comment
      @message = 'That comment does not exist'
      @link = '/comments'
      erb :"/status/failure.html"
    else
      redirect "/posts/#{@comment.post.id}"
    end
  end

  # GET: /comments/5/edit
  get '/comments/:id/edit' do
    @user = User.find_by(id: session[:user_id])
    @comment = Comment.find_by(id: params[:id])
    if !@user
      @message = 'You must log in to comment'
      @link = '/users/login'
      erb :"/status/failure.html"
    elsif !@comment
      @message = 'That comment does not exist'
      @link = '/comments'
      erb :"/status/failure.html"
    else
      @post = @comment.post
      erb :"/comments/edit.html"
    end
  end

  # PATCH: /comments/5
  patch '/comments/:id' do
    @user = User.find_by(id: session[:user_id])
    @comment = Comment.find_by(id: params[:id])
    @comment.body = params[:body]
    if !@user
      @message = 'You must log in to comment'
      @link = '/users/login'
      erb :"/status/failure.html"
    elsif !@comment
      @message = 'That comment does not exist'
      @link = '/comments'
      erb :"/status/failure.html"
    elsif !@comment.save
      @message = "#{@comment.errors.messages.keys.first}: #{@comment.errors.messages.values.first.first}"
      @link = "/comments/#{comment.id}/edit"
      erb :"/status/failure.html"
    else
      @message = 'Comment successfully edited'
      @link = "/comments/#{comment.id}"
      erb :"/status/success.html"
    end
  end

  get '/comments/:id/delete' do
    @user = User.find_by(id: session[:user_id])
    @comment = Comment.find_by(id: params[:id])
    if !@user
      @message = 'You need to log in to delete a comment'
      @link = '/users/login'
      erb :"/status/failure.html"
    elsif !@comment
      @message = "The comment with id #{params[:id]} does not exist"
      @link = '/comments'
      erb :"/status/failure.html"
    elsif @comment.user != @user && !@user.is_admin
      @message = 'You do not have permission to delete this comment'
      @link = '/comments'
      erb :"/status/failure.html"
    else
      erb :"/comments/delete.html"
    end
  end
  # DELETE: /comments/5/delete
  delete '/comments/:id' do
    @user = User.find_by(id: session[:user_id])
    @comment = Comment.find_by(id: params[:id])
    if !@user
      @message = 'You need to log in to delete a comment'
      @link = '/users/login'
      erb :"/status/failure.html"
    elsif !@comment
      @message = "The comment with id #{params[:id]} does not exist"
      @link = '/comments'
      erb :"/status/failure.html"
    elsif @comment.user != @user && !@user.is_admin
      @message = 'You do not have permission to delete this comment'
      @link = '/comments'
      erb :"/status/failure.html"
    else
      @comment.destroy
      @message = "Comment by #{@comment.username} was deleted"
      @link = '/comments'
      erb :"/status/success.html"
    end
  end
end
