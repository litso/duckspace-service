require 'active_record'
require 'json'
require 'sinatra'
require 'uri'

# DATABASE_URL=mysql://user:pass@localhost/duckspace?reconnect=true
uri = URI(ENV['DATABASE_URL'])
`mysqladmin -f -u root create #{uri.path[1..-1]}` if ENV['RACK_ENV'] == 'development'
ActiveRecord::Base.establish_connection(
  :adapter   => "mysql2",
  :host      => uri.host,
  :username  => uri.user,
  :password  => uri.password,
  :database  => uri.path[1..-1],
  :reconnect => true
)
connection = ActiveRecord::Base.connection
connection.select_all("show tables").map do |r|
  r.values.each { |table| puts "Dropping: #{table}"; connection.execute("drop table #{table}") }
end
ActiveRecord::Migration.create_table :locations
ActiveRecord::Migration.create_table :posts do |t|
  t.integer :location_id
  t.string  :url
  t.integer :user_id
  t.string  :comment
end

class Location < ActiveRecord::Base
end

class Post < ActiveRecord::Base
end

location1 = Location.create
location2 = Location.create
location3 = Location.create
Post.create(
  :location_id => location1.id,
  :url         => 'https://avatars3.githubusercontent.com/u/73529?v=2&s=460',
  :user_id     => 'litso',
  :comment     => 'foo'
)
Post.create(
  :location_id => location1.id,
  :url         => 'https://avatars3.githubusercontent.com/u/1147309?v=2&s=460',
  :user_id     => 'nizebulous',
  :comment     => 'bar'
)
Post.create(
  :location_id => location2.id,
  :url         => 'https://avatars1.githubusercontent.com/u/236915?v=2&s=460',
  :user_id     => 'siggy',
  :comment     => 'baz'
)

get '/' do
  "Hello World! DEVELOP"
end

get '/locations' do
  JSON.generate({
    :err => 0,
    :results => Location.all.as_json,
  })
end

get '/location/:location_id' do
  JSON.generate({
    :err => 0,
    :results => Post.find_all_by_location_id(params[:location_id].to_i).as_json,
  })
end

get '/post/:post_id' do
  post_id = params[:post_id].to_i
  JSON.generate({
    :err => 0,
    :results => Post.find(post_id).as_json,
  })
end
