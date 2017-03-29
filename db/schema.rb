# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_170_315_151_221) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'partners', id: :serial, force: :cascade do |t|
    t.string 'name'
    t.string 'slug'
    t.string 'summary'
    t.string 'contact_name'
    t.string 'contact_email'
    t.text 'body'
    t.string 'logo_file_name'
    t.string 'logo_content_type'
    t.integer 'logo_file_size'
    t.datetime 'logo_updated_at'
    t.string 'white_logo_file_name'
    t.string 'white_logo_content_type'
    t.integer 'white_logo_file_size'
    t.datetime 'white_logo_updated_at'
    t.string 'icon_file_name'
    t.string 'icon_content_type'
    t.integer 'icon_file_size'
    t.datetime 'icon_updated_at'
    t.boolean 'published'
    t.boolean 'featured'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'cover_file_name'
    t.string 'cover_content_type'
    t.integer 'cover_file_size'
    t.datetime 'cover_updated_at'
    t.string 'website'
  end
end
