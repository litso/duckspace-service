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
