class Post < ActiveRecord::Base
  validates :title, :body, uniqueness: true
  validates :user_id, presence: true
end
