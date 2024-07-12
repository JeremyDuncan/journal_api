class TagsController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  before_action :set_tag, only: [:destroy]
  before_action :set_tag_type, only: [:destroy_tag_type, :update_tag_type]

  # GET /tags or /tags.json
  def index
    @tags = Tag.all
    render json: @tags.as_json(include: :tag_type)
  end

  # GET /tag_types or /tag_types.json
  def index_tag_types
    @tag_types = TagType.all
    render json: @tag_types
  end

  # POST /tags or /tags.json
  def create
    tag_type = TagType.find_or_create_by(name: tag_params[:tag_type])
    @tag = Tag.new(name: tag_params[:name], tag_type: tag_type)

    if @tag.save
      render json: @tag.as_json(include: :tag_type), status: :created
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # POST /tag_types or /tag_types.json
  def create_tag_type
    @tag_type = TagType.new(tag_type_params)

    if @tag_type.save
      render json: @tag_type, status: :created
    else
      render json: @tag_type.errors, status: :unprocessable_entity
    end
  end

  # PUT /tag_types/:id or /tag_types/:id.json
  def update_tag_type
    if @tag_type.nil?
      render json: { error: 'TagType not found' }, status: :not_found
      return
    end

    if @tag_type.update(tag_type_params)
      render json: @tag_type, status: :ok
    else
      render json: @tag_type.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tags/:id or /tags/:id.json
  def destroy
    @tag.destroy!
    head :no_content
  end

  # DELETE /tag_types/:id or /tag_types/:id.json
  def destroy_tag_type
    @tag_type.destroy!
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find(params[:id])
  end

  def set_tag_type
    @tag_type = TagType.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @tag_type = nil
  end

  # Only allow a list of trusted parameters through.
  def tag_params
    params.require(:tag).permit(:name, :tag_type)
  end

  def tag_type_params
    params.require(:tag_type).permit(:name, :color)
  end
end
