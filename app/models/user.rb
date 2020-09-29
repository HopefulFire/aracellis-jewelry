class User < ActiveRecord::Base
  validates :username, :email_address, uniqueness: true
  has_secure_password

  has_many :comments
  has_many :posts
  has_many :images
end
