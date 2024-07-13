class PostsController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  before_action :set_post, only: %i[show edit update destroy]

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
                   .includes(tags: :tag_type) # Preload associations to avoid N+1 queries
                   .order(created_at: :desc)
                   .paginate(page: page, per_page: per_page)
    else
      @posts = Post.includes(tags: :tag_type) # Preload associations to avoid N+1 queries
                   .order(created_at: :desc)
                   .paginate(page: page, per_page: per_page)
    end

    render json: {
      posts: @posts.as_json(include: { tags: { include: :tag_type } }),
      total_pages: @posts.total_pages,
      current_page: @posts.current_page,
      next_page: @posts.next_page,
      prev_page: @posts.previous_page
    }
  end

  # GET /posts/1 or /posts/1.json
  def show
    render json: @post.as_json(include: { tags: { include: :tag_type } })
  end

  # POST /posts or /posts.json
  def create
    # Check if created_at is present in the parameters
    if params[:created_at].present?
      @post = Post.new(post_params.merge(created_at: params[:created_at]))
    else
      @post = Post.new(post_params)
    end

    if @post.save
      if params[:tags].present?
        params[:tags].each do |tag_name|
          tag = Tag.find_or_create_by(name: tag_name)
          @post.tags << tag
        end
      end
      render json: @post.as_json(include: { tags: { include: :tag_type } }), status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.update(post_params)
      if params[:tags].present?
        @post.tags.clear
        params[:tags].each do |tag_name|
          tag = Tag.find_or_create_by(name: tag_name)
          @post.tags << tag
        end
      else
        @post.tags.clear
      end
      render json: @post.as_json(include: { tags: { include: :tag_type } }), status: :ok, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.transaction do
      @post.post_tags.destroy_all
      @post.destroy
    end

    respond_to do |format|
      format.json { head :no_content }
    end
  rescue ActiveRecord::RecordNotDestroyed => e
    respond_to do |format|
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end

  # GET /posts/search or /posts/search.json
  def search
    query = params[:query]
    @posts = Post.joins(tags: :tag_type)
                 .where('posts.title ILIKE :query OR posts.content ILIKE :query OR tags.name ILIKE :query OR tag_types.name ILIKE :query', query: "%#{query}%")
                 .distinct
                 .includes(tags: :tag_type) # Preload associations to avoid N+1 queries
                 .order(created_at: :desc)
                 .paginate(page: params[:page], per_page: params[:limit] || 5)

    render json: {
      posts: @posts.as_json(include: { tags: { include: :tag_type } }),
      total_pages: @posts.total_pages,
      current_page: @posts.current_page,
      next_page: @posts.next_page,
      prev_page: @posts.previous_page
    }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  # def post_params
  #   params.require(:post).permit(:title, :content)
  # end

  def post_params
    params.require(:post).permit(:title, :content, :created_at, tags: [])
  end
end
