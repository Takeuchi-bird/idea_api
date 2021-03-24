class IdeasController < ApplicationController
  def create
    # 1. カテゴリをDBから検索
    @category = Category.find_by(name: params[:category_name])

    # 2. カテゴリがなければ、カテゴリを作成（Category.new or Category.create）
    if @category.nil?
      @category = Category.create(name: params[:category_name])
    end

    @idea = Idea.new(category_id: @category.id, body: params[:body])

    if @idea.save
      render status: 201
    else
      render status: 422
    end
  end

  def index
    # カテゴリが指定されている場合、カテゴリに紐づくアイデアを返す
    if params[:category_name].present?
      @category = Category.find_by(name: params[:category_name])
      # カテゴリが存在しない場合、404
      if @category.nil?
        render status: 404 and return
      end
      @ideas = Idea.find_by(category_id: @category.id)
    else
      # カテゴリが指定されていない場合
      @ideas = Idea.all
    end
    render json: { data: ActiveModelSerializers::SerializableResource.new(@ideas, each_serializer: IdeaSerializer) }
  end

  # private
  # def idea_params
  #   params.require(:キー(モデル名)).permit(:カラム名１,：カラム名２,・・・).marge(カラム名: 入力データ)
  # end

  # def index_json(ideas)
  #   (ideas, each_serializer: IdeaSerializer)
  # end
end
