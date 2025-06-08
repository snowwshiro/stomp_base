require 'rails_helper'

RSpec.describe "Blogs", type: :request do
  let(:category) { Category.create!(name: "Test Category", description: "Test description") }
  let(:test_post) { Post.create!(title: "Test Post", content: "Test content", author: "Test Author", status: "published", published_at: 1.day.ago, category_ids: [category.id]) }

  describe "GET /index" do
    it "returns http success" do
      get "/blog"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/blog/#{test_post.id}"
      expect(response).to have_http_status(:success)
    end
  end

end
