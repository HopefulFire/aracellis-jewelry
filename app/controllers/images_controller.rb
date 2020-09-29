class ImagesController < ApplicationController

  # GET: /images
  get "/images" do
    erb :"/images/index.html"
  end

  # GET: /images/new
  get "/images/new" do
    erb :"/images/new.html"
  end

  # POST: /images
  post "/images" do
    redirect "/images"
  end

  # GET: /images/5
  get "/images/:id" do
    erb :"/images/show.html"
  end

  # GET: /images/5/edit
  get "/images/:id/edit" do
    erb :"/images/edit.html"
  end

  # PATCH: /images/5
  patch "/images/:id" do
    redirect "/images/:id"
  end

  # DELETE: /images/5/delete
  delete "/images/:id/delete" do
    redirect "/images"
  end
end
