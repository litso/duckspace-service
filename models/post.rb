class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  mount_uploader :image, ImageUploader
  def url
    self.image_url
  end
end
