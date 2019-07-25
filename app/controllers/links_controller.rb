class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  # GET /links
  def index
    @links = current_user.links
  end

  # GET /links/1
  def show
  end

  # GET /links/new
  def new
    @link = Link.new(link_params)
    @link.set_url

    load_tags
  end

  # POST /links
  def create
    @link = current_user.links.new(link_params)

    if @link.save
      create_tags
      redirect_to @link, notice: 'Link was successfully created.'
    else
      render :new
    end
  end

  # DELETE /links/1
  def destroy
    @link.destroy
    redirect_to links_url, notice: 'Link was successfully destroyed.'
  end

  def new_link; end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    def link_params
      params.require(:link).permit(:url, :full_url)
    end

    def create_tags
      if params[:url][:tags]
        params[:url][:tags].each do |tag|
          @link.tags << Tag.find_or_create_by(name: tag) if !tag.empty?
        end
      end
    end

    def load_tags
      @tags_selects = load_tags_suggested(@link.url)
    end
end
