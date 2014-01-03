class PostsController < ApplicationController
  #users need to be logged in to create a new post
  #we don't want this for index, show or search, just the other actions
  before_filter :authenticate_user!, :except => [:index, :show, :search]

  # GET /posts
  # GET /posts.json
  def index
    #@all = Post.all
    @all = Post.order('created_at DESC').page params[:page]
    @searchresults = @all
    @search = Post.search(params[:search])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @searchresults }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @search = Post.search(params[:search])
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @post }
    end
  end

  # POST /posts/search
  def search
    @all = Post.all
    @searchresults = get_search_results()

    respond_to do |format|
      format.html # search.html.erb
      format.json { render :json => @searchresults }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @search = Post.search(params[:search])
    @post = Post.new
    3.times { tag = @post.tags.build }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @search = Post.search(params[:search])
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        send_new_post_email(@post)
        format.html  { redirect_to(@post,
                                   :notice => 'Post was successfully created.') }
        format.json  { render :json => @post,
                              :status => :created, :location => @post }
      else
        format.html  { render :action => "new" }
        format.json  { render :json => @post.errors,
                              :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, :notice => 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
  def get_search_results
    @search = Post.search(params[:search])
    if params[:search].nil? or params[:search]["title_or_content_or_tags_name_contains"].blank?
      @search.all
    else
      @search.select('DISTINCT post_id, posts.*')
    end
  end

  def send_new_post_email(post)
    if Rails.env.production?
      User.all.each do |user|
        TubeMailer.new_post_mail(post, user).deliver if user.send_email?
      end
    end
  end

end
