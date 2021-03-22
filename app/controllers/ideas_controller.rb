class IdeasController < ApplicationController
  def create
    # 1. カテゴリをDBから検索
    @category = Category.find_by(name: params[:category_name])

    # 2. カテゴリがなければ、カテゴリを作成（Category.new or Category.create）
    if @category.nil?
      @category_created = Category.create(name: params[:category_name])
      Idea.create(category_id: @category_created.id, body: params[:body])
    else
      # Idea.create(id: （自動で決まる）,category_id: @category.id, body: params[:body])
      Idea.create(category_id: @category.id, body: params[:body])
    end

    # 3. ideaをcreate

    render status: 201
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
