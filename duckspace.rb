require 'active_record'
require 'json'
require 'sinatra'
require 'uri'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'carrierwave/processing/mini_magick'

#
# DB Setup
#

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

#
# Schema
#

ActiveRecord::Migration.create_table :locations do |t|
  t.string :name
end
ActiveRecord::Migration.create_table :posts do |t|
  t.integer :location_id
  t.string  :image
  t.integer :user_id
  t.string  :comment
end
ActiveRecord::Migration.create_table :users do |t|
  t.string  :name
end

#
# Carrierwave Config
#
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
    :region                 => 'us-west-1'
  }
  config.fog_directory  = 'duckspace-images'
  config.fog_public     = true
end

#
# Carrierwave Uploader
#
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog
  version :thumb do
    process :resize_to_fill => [200,200]
  end
  def store_dir
    ENV['RACK_ENV'].nil? ? (primary_folder = "test") : (primary_folder = ENV['RACK_ENV'])
    "#{primary_folder}/uploads/posts/#{model.id}/images"
  end
end

#
# Models
#

class Location < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  mount_uploader :image, ImageUploader
  def url
    self.image_url
  end
end

class User < ActiveRecord::Base
  has_many :posts
end

#
# Seed data
#

location1 = Location.create(:name => 'location1')
location2 = Location.create(:name => 'location2')
location3 = Location.create(:name => 'location3')
user1 = User.create(:name => 'litso')
user2 = User.create(:name => 'nizebulous')
user3 = User.create(:name => 'siggy')
Post.create(
  :location_id => location1.id,
  :image       => 'https://avatars3.githubusercontent.com/u/73529?v=2&s=460',
  :user_id     => user1.id,
  :comment     => 'foo'
)
Post.create(
  :location_id => location1.id,
  :image       => 'https://avatars3.githubusercontent.com/u/1147309?v=2&s=460',
  :user_id     => user2.id,
  :comment     => 'bar'
)
Post.create(
  :location_id => location2.id,
  :image       => 'https://avatars1.githubusercontent.com/u/236915?v=2&s=460',
  :user_id     => user3.id,
  :comment     => 'baz'
)

#
# Routes
#

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
    :results => Location.find(params[:location_id].to_i).as_json,
  })
end

get '/posts/?' do
  posts = if params[:location_id]
    Location.find(params[:location_id].to_i).posts
  elsif params[:user_id]
    User.find(params[:user_id].to_i).posts
  else
    Post.all
  end

  JSON.generate({
    :err => 0,
    :results => posts.as_json,
  })
end

get '/post/:post_id' do
  post_id = params[:post_id].to_i
  JSON.generate({
    :err => 0,
    :results => Post.find(post_id).as_json,
  })
end

get '/users' do
  JSON.generate({
    :err => 0,
    :results => User.all.as_json,
  })
end

get '/user/:user_id' do
  user_id = params[:user_id].to_i
  JSON.generate({
    :err => 0,
    :results => User.find(user_id).as_json,
  })
end

post '/upload' do
  post = Post.new
  post.image = params[:file]
  post.location_id = params[:location_id].to_i
  post.user_id = params[:user_id].to_i
  post.comment = params[:comment]
  post.save
  JSON.generate({
    :err => 0,
    :results => [post.as_json]
  })
end
