require 'mechanize'
require_relative 'client'

ec = Easycall::Client.new 'jasiek83', 'dupajasia83'
puts ec.funds

