class ChannelsUser < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  # has attributes for date_joined and role
end