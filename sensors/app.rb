# coding: utf-8
require 'json'

CONFIG = JSON.parse(File.read("sensors/config.json"))
CACHE = {}

Thread.new do
  loop do
    MQTT::Client.connect(ENV['MQTT_URI'], clean_session: false, client_id: 'sensors-app') do |c|
      topics = CONFIG.keys.map { |k| "devices/#{k}" }
      c.subscribe(*topics)
      c.get do |topic, message|
        CACHE[topic] = JSON.parse(message) rescue {}
      end
    end
  end
end

module Sensors
  class App < Sinatra::Base
    def message_for_device(device)
      CACHE["devices/#{device}"] || {}
    end
    
    def text_for_device(device)
      message = message_for_device(device)

      output = []
      if ts = message["timestamp"]
        ts = Time.parse(message["timestamp"]) rescue Time.at(message["timestamp"].to_i)
        output << ts
      else
        output << "No data available, try again later"
      end
      
      if t = message["temperature"]
        output << "Temperature: %.2f C" % t
      end

      if h = message["humidity"]
        output << "Humidity: %.2f %RH" % h
      end

      if p = message["pressure"]
        output << "Pressure: %.2f hPa" % p
      end
      output.join("\n")
    end
    
    get '/:device' do |device|
      builder do |xml|
        xml.CiscoIPPhoneText do |t|
          t.Title CONFIG[device]
          t.Text text_for_device(device)
        end
      end
    end
    
    get '/' do
      builder do |xml|
        xml.CiscoIPPhoneMenu do |m|
          CONFIG.each_pair do |device, description|
            m.MenuItem do |mi|
              mi.Name description
              mi.URL url(device)
            end
          end
        end
      end
    end
  end
end
