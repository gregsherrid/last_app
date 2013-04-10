# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation

  #does attr_accessor :password, :password_confirmation, among other things
  has_secure_password

  before_save { email.downcase! }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\s\-.]+\.[a-z]+\z/i

  validates :email, presence: true, format: { with: EMAIL_REGEX },
  					uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
