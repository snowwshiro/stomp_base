class BlogController < ApplicationController
  before_action :set_post, only: [:show]
  
  def index
    @posts = Post.published.recent.includes(:categories)
    @categories = Category.with_posts
    @featured_posts = @posts.limit(3)
    @recent_posts = @posts.limit(5)
  end

  def show
    redirect_to blog_path unless @post.published?
  end
  
  private
  
  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to blog_path, alert: "記事が見つかりません"
  end
end
