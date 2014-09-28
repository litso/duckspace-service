require 'json'
require 'sinatra'

#
# Routes
#

get '/' do
  @locations = Location.all
  @users = User.all
  erb :index
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

post '/location/new' do
  location = Location.new
  location.name = params[:name]
  location.save

  JSON.generate({
    :err => 0,
    :results => [location.as_json],
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

post '/user/new' do
  user = User.new
  adjectives = Word.where(:part_of_speech => 'adjective').order('RAND()').first(2)
  noun = Word.where(:part_of_speech => 'noun').order('RAND()').first()
  user.name = adjectives[0].word.capitalize + adjectives[1].word.capitalize + noun.word.capitalize
  user.save

  JSON.generate({
    :err => 0,
    :results => [user.as_json],
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
