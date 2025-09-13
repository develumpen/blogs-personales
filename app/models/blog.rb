class Blog < ApplicationRecord
  attr_accessor :feed_urls

  validates_presence_of :url, :title, :description, :feed_url
  validate :is_valid_url

  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :pending, -> { where(accepted_at: nil) }

  def accept!
    return unless accepted_at.nil?
    update! accepted_at: Time.current
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
