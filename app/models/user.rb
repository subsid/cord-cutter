class User < ApplicationRecord
	has_many :channels_users
	has_many :channels, :through => :channels_users  # Edit :needs to be plural same as the has_many relationship   
  
	def self.find_or_create_from_auth_hash(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
			user.email = auth.info.email
			user.picture = auth.info.image
			user.save!
		end
	end
end