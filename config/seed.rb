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

adjectives = [
  'awesome',
  'burly',
  'agressive',
  'aged',
  'beneficial',
  'babyish'
]
adjectives.each do |adj|
  Word.create(:word => adj, :part_of_speech => 'adjective')
end
nouns = [
  'data',
  'food',
  'bird',
  'internet',
  'fact'
]
nouns.each do |noun|
  Word.create(:word => noun, :part_of_speech => 'noun')
end
