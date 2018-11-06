class UserChannels < ActiveRecord::Migration[5.2]
  def change
    create_table 'user_channels', :id => false do |t|
     t.references 'users'
     t.references 'channels'
   end
  end
end
