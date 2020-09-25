class User < ActiveRecord::Base
  validates :username, uniqueness: true
  validates :email_address, uniqueness: { case_sensitive: false }
  validates :is_admin, presence: true
  has_secure_password
end
