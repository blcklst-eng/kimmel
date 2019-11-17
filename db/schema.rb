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

ActiveRecord::Schema.define(version: 2019_06_04_145815) do

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

  create_table "call_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.json "metadata", default: {}
    t.integer "sort_key", null: false
    t.integer "call_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["call_id", "most_recent"], name: "index_call_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["call_id", "sort_key"], name: "index_call_transitions_parent_sort", unique: true
    t.index ["deleted_at"], name: "index_call_transitions_on_deleted_at"
  end

  create_table "calls", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "type", null: false
    t.string "sid"
    t.integer "duration", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "recorded", default: false
    t.string "conference_sid"
    t.boolean "internal", default: false, null: false
    t.boolean "viewed", default: false, null: false
    t.bigint "ring_group_call_id"
    t.boolean "quality_issue", default: false, null: false
    t.index ["created_at"], name: "index_calls_on_created_at"
    t.index ["deleted_at"], name: "index_calls_on_deleted_at"
    t.index ["ring_group_call_id"], name: "index_calls_on_ring_group_call_id"
    t.index ["sid"], name: "index_calls_on_sid", unique: true
    t.index ["user_id"], name: "index_calls_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "walter_id"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number", null: false
    t.string "email"
    t.string "company"
    t.string "occupation"
    t.boolean "hiring_authority", default: false
    t.boolean "saved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.datetime "last_contact_at"
    t.text "notes"
    t.index ["deleted_at"], name: "index_contacts_on_deleted_at"
    t.index ["first_name"], name: "index_contacts_on_first_name"
    t.index ["last_contact_at"], name: "index_contacts_on_last_contact_at"
    t.index ["last_name"], name: "index_contacts_on_last_name"
    t.index ["phone_number"], name: "index_contacts_on_phone_number"
    t.index ["user_id", "phone_number"], name: "index_contacts_on_user_id_and_phone_number", unique: true
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "contact_id", null: false
    t.boolean "read", default: false
    t.datetime "last_message_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["contact_id"], name: "index_conversations_on_contact_id"
    t.index ["deleted_at"], name: "index_conversations_on_deleted_at"
    t.index ["last_message_at"], name: "index_conversations_on_last_message_at"
    t.index ["user_id"], name: "index_conversations_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.string "type", null: false
    t.text "body"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["created_at"], name: "index_messages_on_created_at"
    t.index ["deleted_at"], name: "index_messages_on_deleted_at"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "call_id", null: false
    t.bigint "contact_id", null: false
    t.string "sid"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "muted", default: false
    t.boolean "on_hold", default: false
    t.index ["call_id"], name: "index_participants_on_call_id"
    t.index ["contact_id"], name: "index_participants_on_contact_id"
    t.index ["deleted_at"], name: "index_participants_on_deleted_at"
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.string "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "forwarding", default: false
    t.string "assignable_type"
    t.bigint "assignable_id"
    t.index ["assignable_id", "assignable_type"], name: "index_phone_numbers_on_assignable_id_and_assignable_type", unique: true, where: "(forwarding = false)"
    t.index ["assignable_type", "assignable_id"], name: "index_phone_numbers_on_assignable_type_and_assignable_id"
    t.index ["deleted_at"], name: "index_phone_numbers_on_deleted_at"
    t.index ["number"], name: "index_phone_numbers_on_number", unique: true
  end

  create_table "recordings", force: :cascade do |t|
    t.bigint "call_id"
    t.string "sid", null: false
    t.integer "duration", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["call_id"], name: "index_recordings_on_call_id"
    t.index ["created_at"], name: "index_recordings_on_created_at"
    t.index ["deleted_at"], name: "index_recordings_on_deleted_at"
  end

  create_table "ring_group_calls", force: :cascade do |t|
    t.bigint "ring_group_id", null: false
    t.string "from_phone_number", null: false
    t.string "from_sid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "missed", default: false, null: false
    t.string "to", default: [], null: false, array: true
    t.index ["created_at"], name: "index_ring_group_calls_on_created_at"
    t.index ["deleted_at"], name: "index_ring_group_calls_on_deleted_at"
    t.index ["ring_group_id"], name: "index_ring_group_calls_on_ring_group_id"
  end

  create_table "ring_group_members", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "ring_group_id", null: false
    t.boolean "available", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_ring_group_members_on_deleted_at"
    t.index ["ring_group_id"], name: "index_ring_group_members_on_ring_group_id"
    t.index ["user_id"], name: "index_ring_group_members_on_user_id"
  end

  create_table "ring_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_ring_groups_on_deleted_at"
  end

  create_table "tagged", force: :cascade do |t|
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_tagged_on_deleted_at"
    t.index ["tag_id"], name: "index_tagged_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_tagged_on_taggable_type_and_taggable_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_tags_on_deleted_at"
  end

  create_table "templates", force: :cascade do |t|
    t.bigint "user_id"
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_templates_on_deleted_at"
    t.index ["user_id"], name: "index_templates_on_user_id"
  end

  create_table "transfer_requests", force: :cascade do |t|
    t.bigint "participant_id"
    t.bigint "receiver_id"
    t.bigint "request_call_id"
    t.bigint "contact_id"
    t.string "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["contact_id"], name: "index_transfer_requests_on_contact_id"
    t.index ["deleted_at"], name: "index_transfer_requests_on_deleted_at"
    t.index ["participant_id"], name: "index_transfer_requests_on_participant_id"
    t.index ["receiver_id"], name: "index_transfer_requests_on_receiver_id"
    t.index ["request_call_id"], name: "index_transfer_requests_on_request_call_id"
  end

  create_table "unrecordable_phone_numbers", force: :cascade do |t|
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "name"
    t.index ["deleted_at"], name: "index_unrecordable_phone_numbers_on_deleted_at"
  end

  create_table "users", force: :cascade do |t|
    t.integer "walter_id"
    t.integer "intranet_id"
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "origin_id"
    t.boolean "call_forwarding", default: false
    t.string "call_forwarding_number"
    t.boolean "available", default: true
    t.text "availability_note"
    t.bigint "screener_number_id"
    t.boolean "recordable", default: true, null: false
    t.string "caller_id_number"
    t.boolean "email_voicemails", default: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["screener_number_id"], name: "index_users_on_screener_number_id"
  end

  create_table "voicemails", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "viewed", default: false
    t.string "sid"
    t.boolean "archived", default: false
    t.string "voicemailable_type", null: false
    t.bigint "voicemailable_id", null: false
    t.index ["created_at"], name: "index_voicemails_on_created_at"
    t.index ["deleted_at"], name: "index_voicemails_on_deleted_at"
    t.index ["voicemailable_type", "voicemailable_id"], name: "index_voicemails_on_voicemailable_type_and_voicemailable_id"
  end

  add_foreign_key "call_transitions", "calls"
  add_foreign_key "calls", "ring_group_calls"
  add_foreign_key "calls", "users"
  add_foreign_key "contacts", "users"
  add_foreign_key "conversations", "contacts"
  add_foreign_key "conversations", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "participants", "calls"
  add_foreign_key "participants", "contacts"
  add_foreign_key "recordings", "calls"
  add_foreign_key "ring_group_calls", "ring_groups"
  add_foreign_key "ring_group_members", "ring_groups"
  add_foreign_key "ring_group_members", "users"
  add_foreign_key "tagged", "tags"
  add_foreign_key "templates", "users"
  add_foreign_key "transfer_requests", "calls", column: "request_call_id"
  add_foreign_key "transfer_requests", "contacts"
  add_foreign_key "transfer_requests", "participants"
  add_foreign_key "transfer_requests", "users", column: "receiver_id"
  add_foreign_key "users", "phone_numbers", column: "screener_number_id"
end
