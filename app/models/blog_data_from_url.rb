require "open-uri"
require "ostruct"

class BlogDataFromUrl
  def self.fetch(url)
    return unless url.present?

    html = URI.open(url)
    doc = Nokogiri::HTML(html)
    feed_urls = doc.css("link[type='application/rss+xml'], link[type='application/atom+xml']")
                  .map { |link|
                    OpenStruct.new(
                      title: link["title"],
                      url: link["href"]
                    )
                  }

    {
      url:,
      title: doc.at("title")&.text&.strip,
      description: doc.at("meta[name='description']")&.[]("content")&.strip,
      feed_urls:
    }
  rescue => e
    Rails.logger.error("[ERROR] => #{e.message}")

    {
      feed_urls: []
    }
  end
end
