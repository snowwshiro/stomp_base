# frozen_string_literal: true

require "rails_helper"

RSpec.describe "StompBase Dashboard API" do
  describe "GET /stomp_base" do
    it "returns the dashboard page" do
      get "/stomp_base"
      expect(response).to have_http_status(:success)
    end

    it "returns HTML content by default" do
      get "/stomp_base"
      expect(response.content_type).to include("text/html")
    end
  end

  describe "GET /stomp_base.json" do
    it "returns JSON response when requested" do
      get "/stomp_base", headers: { "Accept" => "application/json" }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /stomp_base/application" do
    it "returns application information" do
      get "/stomp_base/application"
      expect(response).to have_http_status(:success)
    end
  end
end
