class Link < ApplicationRecord
  # Relations
  has_many :taggings
  has_many :tags, through: :taggings

  belongs_to :user

  # Callbacks
  before_save :set_url
  
  def set_url
    self.url = full_url.match(/^(http|https)?:?(\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)/)[0] if full_url
  end
end
