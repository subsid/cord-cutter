class Channel < ApplicationRecord
  has_and_belongs_to_many :stream_packages
  has_many :channels_user
end
