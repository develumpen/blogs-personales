class FeedItemsController < ApplicationController
  def show
    @feed_items = FeedItem.order(published_at: :desc)
  end
end
