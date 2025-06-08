# frozen_string_literal: true

module StompBase
  module Pages
    class DashboardComponent < StompBase::BaseComponent
      def initialize(title: nil)
        super()
        @title = title || t("stomp_base.dashboard.title")
      end

      def system_info
        @system_info ||= build_system_info
      end

      def performance_info
        @performance_info ||= build_performance_info
      end

      def environment_badge_color
        case system_info[:environment]
        when "production"
          "bg-red-100 text-red-800 border-red-200"
        when "staging"
          "bg-yellow-100 text-yellow-800 border-yellow-200"
        when "development"
          "bg-green-100 text-green-800 border-green-200"
        else
          "bg-gray-100 text-gray-800 border-gray-200"
        end
      end

      def memory_percentage
        total_memory_mb = 8192 # Default assumption, could be made configurable
        ((performance_info[:memory] / total_memory_mb) * 100).round(1)
      end

      private

      attr_reader :title

      def build_system_info
        basic_info.merge(database_info).merge(detailed_system_info)
      end

      def basic_info
        {
          rails_version: Rails.version,
          ruby_version: RUBY_VERSION,
          environment: Rails.env
        }
      end

      def database_info
        {
          database: database_name,
          adapter: database_adapter,
          tables: table_count
        }
      end

      def detailed_system_info
        {
          host: hostname,
          platform: RUBY_PLATFORM,
          process_id: Process.pid,
          current_time: Time.current
        }
      end

      def build_performance_info
        {
          uptime: uptime_seconds,
          uptime_formatted: format_uptime(uptime_seconds),
          memory: memory_usage
        }
      end

      def database_name
        ActiveRecord::Base.connection.current_database
      rescue StandardError
        "Unknown"
      end

      def database_adapter
        ActiveRecord::Base.connection.adapter_name
      rescue StandardError
        "Unknown"
      end

      def table_count
        ActiveRecord::Base.connection.tables.count
      rescue StandardError
        0
      end

      def hostname
        Socket.gethostname
      rescue StandardError
        "Unknown"
      end

      def uptime_seconds
        return @application_start_time if defined?(@application_start_time)

        calculate_process_uptime
      rescue StandardError
        0
      end

      def calculate_process_uptime
        pid_start_time = process_start_time
        return 0 if pid_start_time.blank?

        parse_uptime(pid_start_time)
      end

      def process_start_time
        `ps -o lstart= -p #{Process.pid}`.strip
      end

      def parse_uptime(pid_start_time)
        start_time = Time.zone.parse(pid_start_time)
        (Time.current - start_time).to_i
      rescue StandardError
        0
      end

      def memory_usage
        case RUBY_PLATFORM
        when /linux/
          linux_memory_usage
        when /darwin/
          macos_memory_usage
        else
          ruby_memory_usage
        end
      rescue StandardError
        0
      end

      def linux_memory_usage
        status = File.read("/proc/#{Process.pid}/status")
        return 0 if status.blank?

        match = status.match(/VmRSS:\s+(\d+)\s+kB/)
        match ? (match[1].to_f / 1024).round(2) : 0
      rescue StandardError
        0
      end

      def macos_memory_usage
        output = `ps -o rss= -p #{Process.pid}`.strip
        output.present? ? (output.to_f / 1024).round(2) : 0
      rescue StandardError
        0
      end

      def ruby_memory_usage
        pages = GC.stat[:heap_allocated_pages]
        page_size = GC::INTERNAL_CONSTANTS[:HEAP_PAGE_SIZE]
        pages * page_size / (1024 * 1024)
      rescue StandardError
        0
      end

      def format_uptime(seconds)
        return "0s" if seconds.zero?

        time_parts = calculate_time_parts(seconds)
        build_uptime_string(time_parts)
      end

      def calculate_time_parts(seconds)
        {
          days: seconds / 86_400,
          hours: (seconds % 86_400) / 3600,
          minutes: (seconds % 3600) / 60,
          secs: seconds % 60
        }
      end

      def build_uptime_string(time_parts)
        parts = build_time_parts(time_parts)
        parts.empty? ? "0s" : parts.join(" ")
      end

      def build_time_parts(time_parts)
        parts = []
        parts << format_time_unit(time_parts[:days], "d")
        parts << format_time_unit(time_parts[:hours], "h")
        parts << format_time_unit(time_parts[:minutes], "m")
        parts << format_time_unit(time_parts[:secs], "s") if parts.empty?
        parts.compact
      end

      def format_time_unit(value, unit)
        return nil unless value&.positive?

        "#{value}#{unit}"
      end
    end
  end
end
