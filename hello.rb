require 'json'
require 'sinatra'

SEED = {
  :locations => [ 1,2,3 ],
  :posts => [
    {
      :id => 4,
      :location_id => 1,
      :url => 'https://avatars3.githubusercontent.com/u/73529?v=2&s=460',
      :user_id => 'litso',
      :comment => 'foo',
    },
    {
      :id => 5,
      :location_id => 1,
      :url => 'https://avatars3.githubusercontent.com/u/1147309?v=2&s=460',
      :user_id => 'nizebulous',
      :comment => 'bar',
    },
    {
      :id => 6,
      :location_id => 2,
      :url => 'https://avatars1.githubusercontent.com/u/236915?v=2&s=460',
      :user_id => 'siggy',
      :comment => 'baz',
    }
  ],
}

get '/' do
  "Hello World! DEVELOP"
end

get '/locations' do
  JSON.generate({
    :err => 0,
    :results => SEED[:locations],
  })
end

get '/location/:location_id' do
  location_id = params[:location_id].to_i
  JSON.generate({
    :err => 0,
    :results => SEED[:posts].select { |h| h[:location_id] == location_id },
  })
end

get '/post/:post_id' do
  post_id = params[:post_id].to_i
  JSON.generate({
    :err => 0,
    :results => SEED[:posts].select { |h| h[:id] == post_id },
  })
end
