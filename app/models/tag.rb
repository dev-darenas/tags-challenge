class Tag < ApplicationRecord
  # Relations 
  has_many :taggings
  has_many :links, through: :taggings
end
