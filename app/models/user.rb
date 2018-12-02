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

        def add_channels(channel_ids, preference)
          if channel_ids
            channel_ids.each do |id|
              c_obj = Channel.find(id)
              self.channels_users.build :preferences => preference, :channel_id => c_obj.id
            end
          end
        end

        def self.recommendation(must_channels_id, good_channels_id, ok_channels_id, packages)
          package_with_channels = packages.map { |p| {"id": p.id,  "cost": p.cost, "channel_ids": p.channels.ids } }
          debugger

          ["foo"]
        end
end
