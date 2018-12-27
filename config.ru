require 'rubygems'
require 'bundler'
Bundler.require
require_relative 'easycall/app'
require_relative 'wx/app'

use Rack::Static, urls: { "/" => "index.xml" }, root: "public"
run Rack::URLMap.new(
      "/easycall" => Easycall::App.new,
      "/weather" => WX::App.new
)
