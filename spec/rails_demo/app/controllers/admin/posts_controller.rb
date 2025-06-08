class Admin::PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  def index
    @posts = Post.includes(:categories).order(created_at: :desc)
  end

  def show
  end

  def new
    @post = Post.new
    @categories = Category.all
  end

  def create
    @post = Post.new(post_params)
    @categories = Category.all
    
    if @post.save
      update_categories
      redirect_to admin_post_path(@post), notice: "記事を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @post.update(post_params)
      update_categories
      redirect_to admin_post_path(@post), notice: "記事を更新しました"
    else
      @categories = Category.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: "記事を削除しました"
  end
  
  private
  
  def set_post
    @post = Post.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:title, :content, :author, :published_at, :status)
  end
  
  def update_categories
    if params[:post][:category_ids].present?
      category_ids = params[:post][:category_ids].reject(&:blank?)
      @post.categories = Category.where(id: category_ids)
    end
  end
end
