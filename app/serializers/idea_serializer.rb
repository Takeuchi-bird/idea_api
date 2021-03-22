class IdeaSerializer < ActiveModel::Serializer
  attributes :id, :category, :body

  def category
    object.category.name
  end
end
