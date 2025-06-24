# frozen_string_literal: true

require "rails_helper"

RSpec.describe "API Root" do
  describe "GET /" do
    it "returns API information" do
      get "/"
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("application/json")
    end

    it "includes expected API information fields" do
      get "/"
      json_response = JSON.parse(response.body)

      expect(json_response).to have_key("message")
      expect(json_response).to have_key("version")
      expect(json_response).to have_key("stomp_base_mounted")
      expect(json_response).to have_key("timestamp")

      expect(json_response["stomp_base_mounted"]).to eq("/stomp_base")
    end
  end

  describe "GET /up" do
    it "returns health check status" do
      get "/up"
      expect(response).to have_http_status(:success)
    end
  end
end
