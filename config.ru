require 'active_record'
Dir['./models/*.rb'].each {|file| require file }
require './config/database'
require './duckspace'
run Sinatra::Application
