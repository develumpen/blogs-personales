# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_13_215308) do
  create_table "blogs", force: :cascade do |t|
    t.string "url", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.string "feed_url", null: false
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "feed_etag"
    t.string "feed_last_modified"
  end

  create_table "feed_items", force: :cascade do |t|
    t.integer "blog_id", null: false
    t.string "title", null: false
    t.string "link", null: false
    t.string "guid", null: false
    t.datetime "published_at", null: false
    t.text "summary"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_id", "guid"], name: "index_feed_items_on_blog_id_and_guid", unique: true
    t.index ["blog_id"], name: "index_feed_items_on_blog_id"
  end

  add_foreign_key "feed_items", "blogs"
end
