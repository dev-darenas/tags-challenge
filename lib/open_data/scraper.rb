module OpenData
  class Scraper
    include HTTParty
    META_TITLE_TAGS = %w(og:title title).freeze

    def initialize(url)
      @tags = []
      url = 'www.' + url if !has_www?(url)
      url = 'https://' + url if !has_https?(url)
      @uri = URI.parse(Addressable::URI.encode(url))

      get_data_tags
    end

    def tags
      @tags.first 10
    end

    private

    def get_data_tags
      make_request
      @document = Nokogiri.parse @response.body

      @document.css('h2', 'h3', 'a', 'p').each do |link|
        link.content.split(/ /).each do |word|
          count_tags(word)
        end
      end

      get_title if !@tags.any?
      @tags.sort! { |a,b| b.count <=> a.count}
    rescue => e
      @tags = []
    end

    def count_tags(word)
      word = word.strip
      return if word.length <= 3
      current_tag = @tags.select { |o| o.name == word }.first
      if current_tag.nil?
        @tags.push(OpenStruct.new(name: word, count: 1))
      else
        current_tag.count += 1
      end
    end

    def has_www?(url)
      !(url.match /^(https:\/\/)*www/).nil?
    end

    def has_https?(url)
      !(url.match /^(https:\/\/)/).nil?
    end

    def make_request
      begin
        @response = get_resource @uri.to_s
        raise ::OpenGraph::Error.new(@response), "Error Request #{@response.code}" unless @response.ok?
      rescue ::HTTParty::ResponseError => e
        raise ::OpenGraph::Error.new(e.response), "Error Request #{e.response.code}"
      end
    end

    def get_resource(url)
      HTTParty.get url
    end

    def get_title
      title = fetch_tags META_TITLE_TAGS
      if title.nil? or title.empty?
        title = @document.title
      end
      @tags.push(OpenStruct.new(name: title || '', count: 1))
    end
  end
end