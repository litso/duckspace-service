require 'active_record'
require './carrierwave'
Dir['./models/*.rb'].each {|file| require file }
require './config/database'
require './duckspace'
run Sinatra::Application