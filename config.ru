require 'active_record'
require './carrierwave'
require './config/database'
Dir['./models/*.rb'].each { |file| require file }
require './config/seed'
require './duckspace'
require './helpers'

use ActiveRecord::ConnectionAdapters::ConnectionManagement

run Sinatra::Application
