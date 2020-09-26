class Image < ActiveRecord::Base
  validates :src, uniqueness: true
  validates :post_id, presence: true

  belongs_to :post
end
