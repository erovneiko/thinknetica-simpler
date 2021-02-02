module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && (path == @path || match_with_id?(@path, path))
      end

      private

      def match_with_id?(path_id, path_num)
        /(?<path1>\/\w+\/):id/ =~ path_id && /(?<path2>\/\w+\/)\d+/ =~ path_num && path1 == path2
      end

    end
  end
end
