class CommentsController < ApplicationController
  # GET: /comments
  get '/comments' do
    erb :"/comments/index.html"
  end

  # GET: /comments/new
  get '/comments/new/:post_id' do
    @post = Post.find_by(id: params[:post_id])
    @user = User.find_by(id: session[:user_id])
    if @post
      erb :"/comments/new.html"
    else
      redirect '/posts'
    end
  end

  # POST: /comments
  post '/comments/:post_id' do
    @comment = Comment.new
    @comment.post_id = params[:post_id]
    @comment.body = params[:body]
    @comment.user_id = session[:user_id]
    if @comment.save
      redirect '/posts/:post_id'
    else
      redirect '/comments/new/:post_id'
    end
  end

  # GET: /comments/5
  get '/comments/:id' do
    @comment = Comment.find_by(id: params[:id])
    @user = User.find_by(id: session[:user_id])
    erb :"/comments/show.html"
  end

  # GET: /comments/5/edit
  get '/comments/:id/edit' do
    @comment = Comment.find_by(id: params[:id])
    if @comment
      erb :"/comments/edit.html"
    else
      redirect '/comments'
    end
  end

  # PATCH: /comments/5
  patch '/comments/:id' do
    redirect '/comments/:id'
  end

  # DELETE: /comments/5/delete
  delete '/comments/:id' do
    @comment = Comments.find_by(id: params[:id])
    @user = User.find_by(id: session[:id])
    @comment.destroy if @user == @comment&.user || @user&.is_admin
    redirect '/comments'
  end
end
