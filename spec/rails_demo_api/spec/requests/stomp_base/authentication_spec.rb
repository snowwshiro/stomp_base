require 'rails_helper'

RSpec.describe "StompBase Authentication API", type: :request do
  describe "API Key Authentication" do
    before do
      # Configure authentication for these tests
      StompBase.configure do |config|
        config.enable_authentication(
          method: :api_key,
          keys: ["test-api-key", "another-valid-key"]
        )
      end
    end

    after do
      # Reset authentication after tests
      StompBase.configure do |config|
        config.disable_authentication
      end
    end

    describe "authenticated requests" do
      it "allows access with valid API key in header" do
        get "/stomp_base", headers: { 
          "X-API-Key" => "test-api-key",
          "Accept" => "application/json"
        }
        expect(response).to have_http_status(:success)
      end

      it "allows access with valid API key in query params" do
        get "/stomp_base?api_key=test-api-key", headers: { 
          "Accept" => "application/json"
        }
        expect(response).to have_http_status(:success)
      end

      it "allows console access with valid API key" do
        post "/stomp_base/console/execute", 
             params: { code: "1 + 1", api_key: "test-api-key" }.to_json,
             headers: { 
               "Content-Type" => "application/json",
               "Accept" => "application/json"
             }
        expect(response).to have_http_status(:success)
      end
    end

    describe "unauthenticated requests" do
      it "denies access without API key" do
        get "/stomp_base", headers: { "Accept" => "application/json" }
        expect(response).to have_http_status(:unauthorized)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("error")
        expect(json_response["error"]).to include("Invalid or missing API key")
      end

      it "denies access with invalid API key" do
        get "/stomp_base", headers: { 
          "X-API-Key" => "invalid-key",
          "Accept" => "application/json"
        }
        expect(response).to have_http_status(:unauthorized)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("error")
      end

      it "returns JSON error response when Accept header is JSON" do
        get "/stomp_base", headers: { "Accept" => "application/json" }
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to include("application/json")
      end
    end
  end

  describe "Basic Authentication" do
    before do
      StompBase.configure do |config|
        config.enable_authentication(
          method: :basic_auth,
          username: "admin",
          password: "secret"
        )
      end
    end

    after do
      StompBase.configure do |config|
        config.disable_authentication
      end
    end

    it "allows access with valid basic auth credentials" do
      credentials = ActionController::HttpAuthentication::Basic.encode_credentials("admin", "secret")
      get "/stomp_base", headers: { 
        "Authorization" => credentials,
        "Accept" => "application/json"
      }
      expect(response).to have_http_status(:success)
    end

    it "denies access with invalid credentials" do
      credentials = ActionController::HttpAuthentication::Basic.encode_credentials("admin", "wrong")
      get "/stomp_base", headers: { 
        "Authorization" => credentials,
        "Accept" => "application/json"
      }
      expect(response).to have_http_status(:unauthorized)
    end

    it "denies access without credentials" do
      get "/stomp_base", headers: { "Accept" => "application/json" }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end