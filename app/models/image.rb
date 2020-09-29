class Image < ActiveRecord::Base
  validates :src, presence: true

  belongs_to :user
  belongs_to :post
end
