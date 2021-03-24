require 'rails_helper'

describe IdeasController, type: :controller do
  before do
    category1 = FactoryBot.create(:category, name: "ios")
    category2 = FactoryBot.create(:category, name: "android")
    FactoryBot.create(:idea, body: "健康促進アプリ", category: category1)
    FactoryBot.create(:idea, body: "体重測定アプリ", category: category2)
  end

  describe 'GET #index' do
    context "正常系" do
      it "アイデア一覧を取得" do
        get :index
        json = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(json['data'].length).to eq(2)
      end

      it "カテゴリを絞り込んで、アイデア一覧を取得" do
        get :index, params: { category_name: 'ios' }
        json = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(json['data'].length).to eq(1)
      end
    end

    context "異常系" do
      it "カテゴリがないため、エラー" do
        get :index, params: { category_name: 'web' }

        expect(response.status).to eq(404)
      end
    end
  end

  describe "POST #create" do
    context "正常系" do
      it "すでに登録されているカテゴリのアイデア登録" do
        get :index, params: { category_name: 'ios' }
        json = JSON.parse(response.body)
        expect(json['data'].length).to eq(1)

        post :create, params: { category_name: 'ios', body: 'ダイエット促進アプリ' }
        expect(response.status).to eq(201)

        get :index, params: { category_name: 'ios' }
        json = JSON.parse(response.body)
        expect(json['data'].length).to eq(2)
      end

      it "登録されていないカテゴリのアイデア登録" do
        post :create, params: { category_name: 'web', body: 'ダイエット促進アプリ' }
        expect(response.status).to eq(201)

        get :index, params: { category_name: 'web' }
        json = JSON.parse(response.body)
        expect(json['data'].length).to eq(1)
      end
    end

    context "異常系" do
      it "パラメータ不足（bodyなし）によるエラー" do
        post :create, params: { category_name: 'web' }
        expect(response.status).to eq(422)
      end

      it "パラメータ不足（category_nameなし）によるエラー" do
        post :create, params: { body: 'リモート健康診断アプリ' }
        expect(response.status).to eq(422)
      end
    end
  end
end
