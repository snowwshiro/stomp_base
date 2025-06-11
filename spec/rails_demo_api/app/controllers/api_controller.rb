class ApiController < ApplicationController
  def info
    render json: {
      message: "Rails Demo API for StompBase",
      version: "1.0.0",
      stomp_base_mounted: "/stomp_base",
      timestamp: Time.current.iso8601
    }
  end
end