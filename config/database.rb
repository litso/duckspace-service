require 'uri'

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
  :reconnect => true,
  :pool      => 5
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
ActiveRecord::Migration.create_table :words do |t|
  t.string :word
  t.string :part_of_speech
end
