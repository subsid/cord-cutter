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
	
	def add_channels(channel_name, preference)
		if channel_name
        	channel_name.each do |mc|
        		c_obj = Channel.find_by_name(mc)
                self.channels_users.build :preferences => preference, :channel_id => c_obj.id	
        	end
        end
	end
end