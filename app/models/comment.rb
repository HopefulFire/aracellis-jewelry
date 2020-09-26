class Comment < ActiveRecord::Base
  validates :body, uniqueness: true
  validates :user_id, :post_id, presence: true

  belongs_to :user, :post
end
