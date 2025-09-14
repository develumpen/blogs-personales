class FeedItem < ApplicationRecord
  belongs_to :blog

  validates_presence_of :title, :link, :guid, :published_at
end
