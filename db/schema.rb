# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200319105154) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "content_images", force: :cascade do |t|
    t.integer "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.string "imageable_type"
    t.index ["imageable_type", "imageable_id"], name: "index_content_images_on_imageable_type_and_imageable_id"
  end

  create_table "dashboards", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "description"
    t.text "content"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "summary"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "user_id"
    t.boolean "private", default: true
    t.boolean "production", default: true
    t.boolean "preproduction", default: false
    t.boolean "staging", default: false
    t.string "application", default: ["rw"], null: false, array: true
    t.boolean "is_highlighted", default: false
    t.boolean "is_featured", default: false
    t.string "user_name"
    t.string "user_role"
    t.string "author_title", default: ""
    t.string "author_image_file_name"
    t.string "author_image_content_type"
    t.integer "author_image_file_size"
    t.datetime "author_image_updated_at"
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question", null: false
    t.text "answer", null: false
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "partners", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "summary"
    t.string "contact_name"
    t.string "contact_email"
    t.text "body"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.string "white_logo_file_name"
    t.string "white_logo_content_type"
    t.integer "white_logo_file_size"
    t.datetime "white_logo_updated_at"
    t.string "icon_file_name"
    t.string "icon_content_type"
    t.integer "icon_file_size"
    t.datetime "icon_updated_at"
    t.boolean "published", default: false
    t.boolean "featured", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cover_file_name"
    t.string "cover_content_type"
    t.integer "cover_file_size"
    t.datetime "cover_updated_at"
    t.string "website"
    t.string "partner_type"
    t.boolean "production", default: true
    t.boolean "preproduction", default: false
    t.boolean "staging", default: false
    t.index ["slug"], name: "index_partners_on_slug"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "user_id"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "static_pages", force: :cascade do |t|
    t.string "title", null: false
    t.text "summary"
    t.text "description"
    t.text "content"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published"
    t.boolean "production", default: true
    t.boolean "preproduction", default: false
    t.boolean "staging", default: false
    t.index ["slug"], name: "index_static_pages_on_slug"
  end

  create_table "temporary_content_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "tools", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.string "summary"
    t.string "description"
    t.text "content"
    t.string "url"
    t.string "thumbnail_file_name"
    t.string "thumbnail_content_type"
    t.integer "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "production", default: true
    t.boolean "preproduction", default: false
    t.boolean "staging", default: false
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "description"
    t.text "content"
    t.boolean "published"
    t.string "summary"
    t.boolean "private", default: true
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "application", default: ["rw"], null: false, array: true
  end

end
