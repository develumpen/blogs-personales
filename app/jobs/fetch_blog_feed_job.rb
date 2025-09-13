require "rss"

class FetchBlogFeedJob < ApplicationJob
  queue_as :default

  def perform(blog_id)
    @blog = Blog.find(blog_id)

    response = Faraday.get(@blog.normalize_feed_url) do |req|
      req.headers["If-None-Match"] = @blog.feed_etag if @blog.feed_etag
      req.headers["If-Modified-Since"] = @blog.feed_last_modified if @blog.feed_last_modified
    end

    if response.status == 200
      feed = RSS::Parser.parse(response.body)
      feed_items = []

      feed.items.each do |item|
        guid = if item.respond_to?(:guid)
          item.guid.content
        elsif item.respond_to?(:id)
          item.id.content
        else
          nil
        end

        published_at = if item.respond_to?(:pubDate)
          item.pubDate
        elsif item.respond_to?(:published)
          item.published
        else
          nil
        end

        summary = if item.respond_to?(:description)
          item.description
        elsif item.respond_to?(:summary)
          item.summary
        else
          nil
        end

        content = if item.respond_to?(:content_encoded)
          item.content_encoded
        elsif item.respond_to?(:description)
          item.description
        else
          nil
        end

        feed_items << {
          title: item.title,
          link: item.link,
          guid:,
          published_at:,
          summary:,
          content:
        }
      end

      ActiveRecord::Base.transaction do
        begin
          @blog.feed_items.create! feed_items
          @blog.update!({
            feed_etag: response.headers["etag"],
            feed_last_modified: response.headers["last-modified"]
          })
        rescue => e
          Rails.logger.error("[ERROR] => #{e.message}")
        end
      end

    elsif response.status == 304
    end
  rescue => e
    Rails.logger.error("[ERROR] #{e.message}")
  end
end
