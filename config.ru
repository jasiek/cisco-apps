require 'rubygems'
require 'bundler'
Bundler.require
require_relative 'easycall/app'
require_relative 'wx/app'

run Rack::URLMap.new(
      "/easycall" => Easycall::App.new,
      "/weather" => WX::App.new
)
