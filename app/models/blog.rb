class Blog < ApplicationRecord
  attr_accessor :feed_urls

  has_many :feed_items, -> { order(published_at: :desc) }, dependent: :destroy

  validates_presence_of :url, :title, :description, :feed_url
  validate :is_valid_url

  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :pending, -> { where(accepted_at: nil) }

  def accept!
    return unless accepted_at.nil?
    update! accepted_at: Time.current
  end

  def normalize_feed_url
    uri = URI.parse(feed_url)

    if uri.scheme.nil? || uri.host.nil?
      URI.join(url, feed_url).to_s
    else
      uri.to_s
    end
  rescue URI::InvalidURIError
    URI.join(url, feed_url).to_s
  end

  private
    def is_valid_url
      uri = URI.parse(url)

      unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
        errors.add(:url, "ha de ser HTTP o HTTPS")
      end

    rescue URI::InvalidURIError
      errors.add(:url, "no es válida")
    end
end
