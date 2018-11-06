class ChannelsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table 'channels_users', :id => false do |t|
     t.integer :user_id
     t.integer :channel_id
     t.string  :preferences
    end 
  end
end
