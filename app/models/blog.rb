class Blog < ApplicationRecord
  attr_accessor :feed_urls

  validates_presence_of :url, :title, :description, :feed_url

  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :pending, -> { where(accepted_at: nil) }

  def accept!
    return unless accepted_at.nil?
    update! accepted_at: Time.current
  end
end
