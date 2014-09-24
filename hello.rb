require 'json'
require 'sinatra'

get '/' do
  "Hello World! DEVELOP"
end

get '/locations' do
  JSON.generate(
    {:foo => :bar2}
  )
end
