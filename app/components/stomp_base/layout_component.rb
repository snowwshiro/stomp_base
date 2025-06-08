# frozen_string_literal: true

module StompBase
  class LayoutComponent < StompBase::BaseComponent
    def initialize(title: nil, breadcrumbs: [])
      super()
      @title = title || t("layout.default_title")
      @breadcrumbs = breadcrumbs
    end

    private

    attr_reader :title, :breadcrumbs

    def active_nav_class(path)
      current_path = helpers.request.path
      return "active" if current_path == path
      return "active" if path != helpers.stomp_base.root_path && current_path.start_with?(path)

      ""
    end
  end
end
