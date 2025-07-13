# frozen_string_literal: true

require "rails_helper"
require "json"

RSpec.describe "StompBase Console API", type: :request do
  describe "GET /stomp_base/console" do
    it "returns the console page" do
      get "/stomp_base/console"
      expect(response).to have_http_status(:success)
    end

    it "returns HTML content by default" do
      get "/stomp_base/console"
      expect(response.content_type).to include("text/html")
    end
  end

  describe "POST /stomp_base/console/execute" do
    it "accepts Ruby code execution requests" do
      post "/stomp_base/console/execute", params: { command: "1 + 1" }
      expect(response).to have_http_status(:success)
    end

    it "returns JSON response when JSON is requested" do
      post "/stomp_base/console/execute",
           params: { command: "1 + 1" }.to_json,
           headers: {
             "Content-Type" => "application/json",
             "Accept" => "application/json"
           }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("application/json")
    end

    it "handles basic Ruby expressions" do
      post "/stomp_base/console/execute",
           params: { command: "2 * 3" }.to_json,
           headers: {
             "Content-Type" => "application/json",
             "Accept" => "application/json"
           }
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key("result")
    end
  end
end
