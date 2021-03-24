class IdeasController < ApplicationController
  def create
    # 1. カテゴリをDBから検索
    @category = Category.find_by(name: params[:category_name])

    # 2. カテゴリがなければ、カテゴリを作成（Category.new or Category.create）
    if @category.nil?
      @category_new = Category.new(name: params[:category_name])
      @idea_new = Idea.new(category_id: @category_new.id, body: params[:body])
    else
      # Idea.create(id: （自動で決まる）,category_id: @category.id, body: params[:body])
      @idea_new = Idea.new(category_id: @category.id, body: params[:body])
    end

    if @idea_new.save
      render status: 201
    else
      render status: 422
    end
  end

  def index
    if params[:category_name].present?
      @category = Category.find_by(name: params[:category_name])
      @ideas = Idea.find_by(category_id: @category.id)
    else
      @ideas = Idea.all
    end
    render json: { data: ActiveModelSerializers::SerializableResource.new(@ideas, each_serializer: IdeaSerializer) }
  end

  # def index_json(ideas)
  #   (ideas, each_serializer: IdeaSerializer)
  # end
end
