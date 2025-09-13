class CreateBlogs < ActiveRecord::Migration[8.0]
  def change
    create_table :blogs do |t|
      t.string :url, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.string :feed_url, null: false
      t.datetime :accepted_at

      t.timestamps
    end
  end
end
