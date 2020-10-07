# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_06_134318) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.bigint "trackable_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "albums", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "user_id", null: false
    t.integer "posts_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "permission_id"
    t.integer "access_requirement_ids", default: [], array: true
    t.boolean "allow_contributors", default: false
    t.index ["permission_id"], name: "index_albums_on_permission_id"
    t.index ["user_id"], name: "index_albums_on_user_id"
  end

  create_table "calendar_events", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.text "description"
    t.string "location"
    t.datetime "datetime_at"
    t.string "price"
    t.string "event_type"
    t.integer "status", default: 4
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["datetime_at"], name: "index_calendar_events_on_datetime_at"
    t.index ["status"], name: "index_calendar_events_on_status"
    t.index ["title"], name: "index_calendar_events_on_title"
    t.index ["user_id"], name: "index_calendar_events_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contributors", force: :cascade do |t|
    t.bigint "album_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["album_id"], name: "index_contributors_on_album_id"
    t.index ["user_id"], name: "index_contributors_on_user_id"
  end

  create_table "event_attendances", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "calendar_event_id"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "feelings", force: :cascade do |t|
    t.string "name"
    t.string "emoji_symbol"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "follows", force: :cascade do |t|
    t.string "followable_type", null: false
    t.bigint "followable_id", null: false
    t.string "follower_type", null: false
    t.bigint "follower_id", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followable_id", "followable_type"], name: "fk_followables"
    t.index ["followable_type", "followable_id"], name: "index_follows_on_followable_type_and_followable_id"
    t.index ["follower_id", "follower_type"], name: "fk_follows"
    t.index ["follower_type", "follower_id"], name: "index_follows_on_follower_type_and_follower_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.integer "status", default: 0
    t.datetime "invite_sent"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["status"], name: "index_friendships_on_status"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "group_posts", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_posts_on_group_id"
    t.index ["post_id"], name: "index_group_posts_on_post_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "owner_id"
    t.boolean "privacy", default: false
    t.string "university"
    t.string "section"
    t.string "president"
    t.string "vice_president"
    t.string "treasure"
    t.string "social_director"
    t.string "secretary"
    t.string "email"
    t.string "calendar_link"
    t.integer "users_count"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_groups_on_name"
    t.index ["owner_id"], name: "index_groups_on_owner_id"
    t.index ["status"], name: "index_groups_on_status"
    t.index ["users_count"], name: "index_groups_on_users_count"
  end

  create_table "groups_users", force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.index ["admin"], name: "index_groups_users_on_admin"
    t.index ["group_id"], name: "index_groups_users_on_group_id"
    t.index ["user_id"], name: "index_groups_users_on_user_id"
  end

  create_table "hashtag_stats", force: :cascade do |t|
    t.string "context"
    t.integer "count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "likeable_id", null: false
    t.string "likeable_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["likeable_id", "likeable_type"], name: "index_likes_on_likeable_id_and_likeable_type"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "avatar_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "media_items", force: :cascade do |t|
    t.string "media_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["media_token"], name: "index_media_items_on_media_token"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "permission_types", force: :cascade do |t|
    t.string "action_name"
    t.string "action_description"
    t.string "action"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["action"], name: "index_permission_types_on_action"
    t.index ["action_name"], name: "index_permission_types_on_action_name"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "action_emoji"
    t.string "action_object"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "permission_type_id"
    t.index ["permission_type_id"], name: "index_permissions_on_permission_type_id"
  end

  create_table "post_activities", force: :cascade do |t|
    t.string "name"
    t.string "emoji_symbol"
    t.integer "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text "body"
    t.datetime "publish_date"
    t.integer "parent_id"
    t.string "parent_type"
    t.integer "comment_count", default: 0
    t.integer "like_count", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "feeling_id"
    t.bigint "activity_id"
    t.bigint "permission_id"
    t.integer "access_requirement_ids", default: [], array: true
    t.boolean "delete_post_after_24_hour", default: false
    t.integer "status"
    t.bigint "location_id"
    t.index ["activity_id"], name: "index_posts_on_activity_id"
    t.index ["feeling_id"], name: "index_posts_on_feeling_id"
    t.index ["location_id"], name: "index_posts_on_location_id"
    t.index ["permission_id"], name: "index_posts_on_permission_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "privacy_settings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "permission_type_id", null: false
    t.string "action_object"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["permission_type_id"], name: "index_privacy_settings_on_permission_type_id"
    t.index ["user_id"], name: "index_privacy_settings_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "class_name"
    t.string "graduation"
    t.string "major"
    t.string "status"
    t.string "attending_university"
    t.string "high_school"
    t.string "from_location"
    t.string "gender"
    t.string "religion"
    t.string "language"
    t.date "date_of_birth"
    t.string "favourite_quotes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "support_tickets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "reason"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_support_tickets_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.text "context"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "otp_secret_key"
    t.string "google_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "albums", "permissions"
  add_foreign_key "albums", "users"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "contributors", "albums"
  add_foreign_key "contributors", "users"
  add_foreign_key "group_posts", "groups"
  add_foreign_key "group_posts", "posts"
  add_foreign_key "likes", "users"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "posts", "feelings"
  add_foreign_key "posts", "locations"
  add_foreign_key "posts", "permissions"
  add_foreign_key "posts", "post_activities", column: "activity_id"
  add_foreign_key "posts", "users"
  add_foreign_key "privacy_settings", "permission_types"
  add_foreign_key "privacy_settings", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "support_tickets", "users"
end
