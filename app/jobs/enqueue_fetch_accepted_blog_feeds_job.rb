class EnqueueFetchAcceptedBlogFeedsJob < ApplicationJob
  queue_as :default

  def perform
    fetch_feed_jobs = Blog.accepted.pluck(:id).map { |blog_id| FetchBlogFeedJob.new(blog_id) }

    ActiveJob.perform_all_later(fetch_feed_jobs)
  end
end
