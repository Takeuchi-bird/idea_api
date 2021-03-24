require 'rails_helper'

describe IdeasController, type: :controller do
  describe 'GET #index' do
    before do
      category1 = FactoryBot.create(:category, name: "ios")
      category2 = FactoryBot.create(:category, name: "android")
      FactoryBot.create(:idea, body: "健康促進アプリ", category: category1)
      FactoryBot.create(:idea, body: "体重測定アプリ", category: category2)
    end

    it "アイデア一覧を取得" do
      get :index
      json = JSON.parse(response.body)
      p json['data']

      expect(response.status).to eq(200)
      expect(json['data'].length).to eq(2)
    end

    it "カテゴリを絞り込んで、アイデア一覧を取得" do
      get :index, params: {category_name: 'ios'}
      json2 = JSON.parse(response.body)
      p json2['data'].length

      expect(response.status).to eq(200)
      expect(json2['data'].length).to eq(1)
    end
  end
end
