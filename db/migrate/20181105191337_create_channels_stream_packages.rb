class CreateChannelsStreamPackages < ActiveRecord::Migration[5.2]
  def change
    create_table :channels_stream_packages, :id => false do |t|
      t.integer :stream_package_id
      t.integer :channel_id
    end
  end
end
