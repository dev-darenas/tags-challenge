class Link < ApplicationRecord
  # Relations
  has_many :taggings
  has_many :tags, through: :taggings

  belongs_to :user

  # Callbacks
  before_save :set_url
  
  def set_url
    if full_url
      uri = Addressable::URI.parse(full_url)
      self.url = uri&.host || '' + uri&.path || ''
    end
  end
end
