module ActionController
  module Routing #:nodoc:
    class RouteSet #:nodoc:
      alias_method :draw_without_health_check_routes, :draw
      def draw
        draw_without_health_check_routes do |map|
          map.connect 'health_check',
            :controller => 'health_check', :action => 'index'
          map.connect 'health_check/:checks',
            :controller => 'health_check', :action => 'check'
          yield map
        end
      end
    end
  end
end

