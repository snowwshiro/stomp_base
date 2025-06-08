require 'rails_helper'

RSpec.describe "Admin::Categories", type: :request do
  let(:category) { Category.create!(name: "Test Category", description: "Test description") }

  describe "GET /index" do
    it "returns http success" do
      get "/admin/categories"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/admin/categories/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "returns http success" do
      post "/admin/categories", params: { category: { name: "New Category", description: "New description" } }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/categories/#{category.id}/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /update" do
    it "returns http success" do
      patch "/admin/categories/#{category.id}", params: { category: { name: "Updated Category" } }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "DELETE /destroy" do
    it "returns http success" do
      delete "/admin/categories/#{category.id}"
      expect(response).to have_http_status(:redirect)
    end
  end

end
