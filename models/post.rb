class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  mount_uploader :image, ImageUploader
  before_create :post_datetime

  def url
    self.image_url
  end

  def post_datetime
    self.posted_at = DateTime.now.utc
  end

end
