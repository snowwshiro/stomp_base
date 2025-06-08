require 'rails_helper'

RSpec.describe "Admin::Posts", type: :request do
  let(:category) { Category.create!(name: "Test Category", description: "Test description") }
  let(:test_post) { Post.create!(title: "Test Post", content: "Test content", author: "Test Author", status: "published", published_at: 1.day.ago, category_ids: [category.id]) }

  describe "GET /index" do
    it "returns http success" do
      get "/admin/posts"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/admin/posts/#{test_post.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/admin/posts/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "returns http success" do
      post "/admin/posts", params: { post: { title: "New Post", content: "New content", author: "New Author", status: "published", published_at: Time.current } }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/posts/#{test_post.id}/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /update" do
    it "returns http success" do
      patch "/admin/posts/#{test_post.id}", params: { post: { title: "Updated Post" } }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "DELETE /destroy" do
    it "returns http success" do
      delete "/admin/posts/#{test_post.id}"
      expect(response).to have_http_status(:redirect)
    end
  end

end
