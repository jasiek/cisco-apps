module Middleware
  class Index < Sinatra::Base
    def initialize(app, app_map)
      @app_map = app_map
      super app
    end
    
    get "/robots.txt" do
      <<EOF
User-agent: *
Disallow: /
EOF
    end

    get "/" do
      builder do |xml|
        xml.CiscoIPPhoneMenu do |m|
          m.Title "Exciting services"
          @app_map.each do |path, app|
            m.MenuItem do |mi|
              mi.Name path
              mi.URL url(path)
            end
          end
        end
      end
    end
  end
end
