class User < ActiveRecord::Base
  validates :username, uniqueness: true
  validates :email_address, uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :posts
  has_many :comments
end
