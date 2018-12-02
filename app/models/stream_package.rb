class StreamPackage < ApplicationRecord
  attr_accessor :name, :cost

  has_and_belongs_to_many :channels
end
