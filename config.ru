require 'rubygems'
require 'bundler'
Bundler.require
require_relative 'easycall/app'
require_relative 'wx/app'
require_relative 'sensors/app'
require_relative 'middleware/index'

# Bail if anything goes wrong.
Thread.abort_on_exception = true

apps = {
      "/easycall" => Easycall::App.new,
      "/weather" => WX::App.new,
      "/sensors" => Sensors::App.new,
}

use Middleware::Index, apps
run Rack::URLMap.new(apps)
