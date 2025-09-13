class AddFeedHeadersToBlogs < ActiveRecord::Migration[8.0]
  def change
    add_column :blogs, :feed_etag, :string
    add_column :blogs, :feed_last_modified, :string
  end
end
