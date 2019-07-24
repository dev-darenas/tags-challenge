module LinksHelper
  def tags(tags)
    tags_html = ''
    tags.each do |tag|
      tags_html = "<span class=\"label label-primary\">#{tag.name}</span>"
    end
    tags_html.html_safe
  end
end
