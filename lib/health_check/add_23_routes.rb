# Copyright (c) 2010-2013 Ian Heggie, released under the MIT license.
# See MIT-LICENSE for details.

# rails prior to 3.0
module ActionController
  module Routing #:nodoc:
    class RouteSet #:nodoc:
      alias_method :draw_without_health_check_routes, :draw

      def draw
        draw_without_health_check_routes do |map|
          map.connect 'health_check',
                      :controller => 'health_check/health_check', :action => 'index'
          map.connect 'health_check.:format',
                      :controller => 'health_check/health_check', :action => 'index'
          map.connect 'health_check/:checks',
                      :controller => 'health_check/health_check', :action => 'index'
          map.connect 'health_check/:checks.:format',
                      :controller => 'health_check/health_check', :action => 'index'
          yield map
        end
      end
    end
  end
end
