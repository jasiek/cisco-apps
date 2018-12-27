require 'rubygems'
require 'bundler'
Bundler.require
require './easycall/app'

run Rack::URLMap.new(
      "/easycall" => Easycall::App.new
    )
