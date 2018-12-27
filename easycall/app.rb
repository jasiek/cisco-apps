require_relative 'client'

module Easycall
  class App < Sinatra::Base
    get '/' do
      builder do |xml|
        xml.CiscoIPPhoneText do |t|
          t.Title "easycall.pl"
          t.Text Easycall::Client.new(ENV['EC_USERNAME'], ENV['EC_PASSWORD']).funds_text
        end
      end
    end
  end
end

