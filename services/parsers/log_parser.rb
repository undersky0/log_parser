require_relative "../base_service"
require_relative "../../lib/error/invalid_file"
require_relative "../../lib/error/empty_file"
require_relative "../../lib/error/perform_not_allowed"

module Services
  module Parsers
    class LogParser < Services::BaseService

      attr_accessor :results

      def initialize(path)
        @log = path
      end

      def allow?
        raise Error::EmptyFile if File.zero?(@log)
        @log = File.open(@log) #TODO: File size check?
        true
      rescue TypeError, Errno::ENOENT
        raise Error::InvalidFile
      end

      def perform_if_allowed
        paths_and_ips = get_paths_and_ips
        path_visits = get_path_visits(paths_and_ips)
        uniq_path_visits = get_uniq_path_visits(paths_and_ips)
        results = {path_visits: path_visits, uniq_path_visits: uniq_path_visits}

        @results = results
      end

      private

      def get_paths_and_ips
        paths_and_ips = []
        @log.each_line do |line|
          path = line.partition(" ").first
          ip = line.partition(" ").last
          paths_and_ips << {path: path, ip: ip} unless path.empty? || ip.empty?
        end
        paths_and_ips
      end

      def get_path_visits(paths_and_ips)
        paths_and_ips.group_by {|x| x[:path]}.map {|k,v| {path:k, visits: v.count}}
        .sort_by { |hash| hash[:visits] }.reverse
      end

      def get_uniq_path_visits(paths_and_ips)
        uniq_path_visits = paths_and_ips.group_by {|x| [x[:path], x[:ip]]}.map {|k,v| {path:k.first, uniq_views: v.count}}
        .sort_by { |hash| hash[:uniq_views] }.reverse
      end

    end # END class
  end
end