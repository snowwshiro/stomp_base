# frozen_string_literal: true

module StompBase
  class DashboardController < StompBase::ApplicationController
    # Disable Rails default layout to use LayoutComponent
    layout false

    def index
      # Display dashboard using View Component
      @dashboard_component = StompBase::Pages::DashboardComponent.new
    end
  end
end
