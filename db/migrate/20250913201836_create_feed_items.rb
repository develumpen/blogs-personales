class CreateFeedItems < ActiveRecord::Migration[8.0]
  def change
    create_table :feed_items do |t|
      t.references :blog, null: false, foreign_key: true
      t.string :title, null: false
      t.string :link, null: false
      t.string :guid, null: false
      t.datetime :published_at, null: false
      t.text :summary
      t.text :content

      t.timestamps
    end

    add_index :feed_items, [ :blog_id, :guid ], unique: true
  end
end
