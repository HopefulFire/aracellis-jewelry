class Post < ActiveRecord::Base
  validates :title, :body, uniqueness: true
  validates :user_id, presence: true

  belongs_to :user
  has_many :images, :comments
end
