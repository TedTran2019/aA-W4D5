# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  password_digest :string           not null
#  session_token   :string           not null
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_session_token  (session_token) UNIQUE
#  index_users_on_username       (username) UNIQUE
#

class User < ApplicationRecord
	validates :username, :password_digest, :session_token, presence: true
	validates :password, length: { minimum: 6, allow_nil: true }
	validates :username, :session_token, uniqueness: true
	after_initialize :ensure_session_token

	attr_reader :password

	has_many :goals,
	foreign_key: :owner_id,
	dependent: :destroy

	has_many :comments,
	as: :commentable,
	dependent: :destroy

	has_many :written_comments,
	class_name: :Comment,
	dependent: :destroy

	def self.generate_session_token
		SecureRandom::urlsafe_base64(16)
	end

	def self.find_by_credentials(username, password)
		user = User.find_by(username: username)
		return user if user && user.is_password?(password)
		nil
	end

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def reset_session_token!
		self.session_token = self.class.generate_session_token
		self.save!
		self.session_token
	end

	def is_password?(password)
		BCrypt::Password.new(self.password_digest).is_password?(password)
	end

	private

	def ensure_session_token
		self.session_token ||= self.class.generate_session_token
	end
end
