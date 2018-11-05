class CreateChannelsStreamPackagesJoin < ActiveRecord::Migration[5.2]
  def change
    create_table :channels_stream_packages_joins, :id => false do |t|
      t.integer :channel_id
      t.integer :stream_package_id
    end
  end
end
