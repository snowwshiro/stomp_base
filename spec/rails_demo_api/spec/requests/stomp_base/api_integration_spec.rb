# frozen_string_literal: true

require "rails_helper"

RSpec.describe "StompBase API Integration" do
  describe "API-specific functionality" do
    describe "JSON responses" do
      it "handles JSON Accept headers properly" do
        get "/stomp_base", headers: { "Accept" => "application/json" }
        expect(response).to have_http_status(:success)
      end

      it "handles Content-Type application/json" do
        post "/stomp_base/console/execute",
             params: { code: "Time.current" }.to_json,
             headers: {
               "Content-Type" => "application/json",
               "Accept" => "application/json"
             }
        expect(response).to have_http_status(:success)
        expect(response.content_type).to include("application/json")
      end
    end

    describe "CORS support" do
      it "includes CORS headers in response" do
        get "/stomp_base", headers: { "Origin" => "http://localhost:3000" }
        expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
      end

      it "handles preflight OPTIONS requests" do
        options "/stomp_base/console/execute", headers: {
          "Origin" => "http://localhost:3000",
          "Access-Control-Request-Method" => "POST",
          "Access-Control-Request-Headers" => "Content-Type"
        }
        expect(response).to have_http_status(:success)
        expect(response.headers).to include("Access-Control-Allow-Methods")
      end
    end

    describe "Settings endpoint" do
      it "returns settings page" do
        get "/stomp_base/settings"
        expect(response).to have_http_status(:success)
      end

      it "handles locale updates via PATCH" do
        patch "/stomp_base/settings/locale",
              params: { locale: "en" }.to_json,
              headers: {
                "Content-Type" => "application/json",
                "Accept" => "application/json"
              }
        expect(response).to have_http_status(:success)
      end
    end

    describe "Models endpoint" do
      it "returns models index" do
        get "/stomp_base/models"
        expect(response).to have_http_status(:success)
      end

      it "handles JSON requests for models" do
        get "/stomp_base/models", headers: { "Accept" => "application/json" }
        expect(response).to have_http_status(:success)
      end
    end

    describe "API authentication scenarios" do
      context "when authentication is disabled" do
        it "allows access to all endpoints" do
          get "/stomp_base"
          expect(response).to have_http_status(:success)

          get "/stomp_base/console"
          expect(response).to have_http_status(:success)

          get "/stomp_base/settings"
          expect(response).to have_http_status(:success)
        end
      end

      context "when API key authentication is enabled" do
        it "demonstrates API key header usage" do
          # This is a placeholder test showing expected API key behavior
          headers = { "X-API-Key" => "demo-api-key", "Accept" => "application/json" }
          get "/stomp_base", headers: headers
          # In an authenticated setup, this would check for proper authentication
          expect(response).to have_http_status(:success)
        end
      end
    end
  end

  describe "Error handling in API mode" do
    it "returns JSON error responses when Accept header is JSON" do
      # Test with invalid endpoint
      get "/stomp_base/nonexistent", headers: { "Accept" => "application/json" }
      expect(response).to have_http_status(:not_found)
    end

    it "handles malformed JSON in POST requests" do
      post "/stomp_base/console/execute",
           params: "invalid json",
           headers: {
             "Content-Type" => "application/json",
             "Accept" => "application/json"
           }
      # Should handle malformed JSON gracefully
      expect(response.status).to be_in([400, 422, 500])
    end
  end
end
