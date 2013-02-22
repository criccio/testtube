class VotesController < ApplicationController
  #users need to be logged in to Like a post
  before_filter :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @vote = @post.votes.create(params[:vote])
    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @vote = @post.votes.find(params[:id])
    @vote.destroy
    redirect_to post_path(@post)
  end
end
