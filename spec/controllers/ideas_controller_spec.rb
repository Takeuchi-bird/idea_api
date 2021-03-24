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

      expect(response.status).to eq(200)
      expect(json['data'].length).to eq(2)
    end
  end
end
