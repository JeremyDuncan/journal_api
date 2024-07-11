class PostsController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    page = params[:page] || 1
    per_page = params[:limit] || 5

    if params[:year].present? && params[:month].present?
      year = params[:year].to_i
      month = params[:month].to_i
      start_date = Date.new(year, month, 1)
      end_date = start_date.end_of_month
      @posts = Post.where(created_at: start_date..end_date)
                   .paginate(page: page, per_page: per_page)
                   .order(created_at: :desc)
    else
      @posts = Post.paginate(page: page, per_page: per_page)
                   .order(created_at: :desc)
    end

    render json: {
      posts: @posts,
      total_pages: @posts.total_pages,
      current_page: @posts.current_page,
      next_page: @posts.next_page,
      prev_page: @posts.previous_page
    }
  end

  # GET /posts/1 or /posts/1.json
  def show
    render json: @post
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.update(post_params)
      render json: @post, status: :ok, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :content)
  end
end
