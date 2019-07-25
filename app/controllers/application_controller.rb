class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  require 'open_data/scraper'

  def load_tags_suggested(url)
    tags = Link.find_by(url: url)&.tags || []
    tags_selects = tags.map { |tag| [tag.name, tag.id] }
    tags_selects = tags_selects + ::OpenData::Scraper.new(@link.full_url).tags.map { |tag| [tag.name, ''] }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username])
  end
end
