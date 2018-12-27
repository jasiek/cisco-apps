require 'rubygems'
require 'bundler'
Bundler.require
require_relative 'easycall/app'
require_relative 'wx/app'
require_relative 'sensors/app'

# Bail if anything goes wrong.
Thread.abort_on_exception = true

use Rack::Static, urls: { "/" => "index.xml" }, root: "public"
run Rack::URLMap.new(
      "/easycall" => Easycall::App.new,
      "/weather" => WX::App.new,
      "/sensors" => Sensors::App.new
)
