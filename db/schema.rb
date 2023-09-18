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

ActiveRecord::Schema[7.0].define(version: 2023_02_11_160555) do
  create_table "active_storage_attachments", charset: "latin1", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "latin1", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "latin1", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "applicant_notes", charset: "latin1", force: :cascade do |t|
    t.bigint "applicant_id"
    t.bigint "user_id"
    t.string "note_type", null: false
    t.text "description"
    t.integer "responsiblity_score", default: 0, null: false
    t.integer "growing_score", default: 0, null: false
    t.integer "culture_score", default: 0, null: false
    t.boolean "hire_applicant", default: false
    t.integer "homework_score", default: 0, null: false
    t.integer "session_score", default: 0, null: false
    t.string "status", default: "ACTIVE"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["applicant_id"], name: "index_applicant_notes_on_applicant_id"
    t.index ["user_id"], name: "index_applicant_notes_on_user_id"
  end

  create_table "applicant_offers", charset: "latin1", force: :cascade do |t|
    t.bigint "applicant_id"
    t.bigint "job_id"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "title", null: false
    t.integer "base_salary", default: 0, null: false
    t.integer "share_stock", default: 0, null: false
    t.datetime "valid_until_date"
    t.string "valid_start_date"
    t.string "status", default: "ACTIVE"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_id"], name: "index_applicant_offers_on_applicant_id"
    t.index ["job_id"], name: "index_applicant_offers_on_job_id"
  end

  create_table "applicants", charset: "latin1", force: :cascade do |t|
    t.bigint "job_id"
    t.string "source_url", null: false
    t.string "portfolio"
    t.string "resume"
    t.string "cover", null: false
    t.string "first_name", null: false
    t.string "middle_name"
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "status", default: "ACTIVE"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stage", default: "NEW"
    t.string "source_type", null: false
    t.string "avatar"
    t.string "rejected_reason"
    t.text "rejected_text"
    t.string "slack_channel_id"
    t.index ["job_id"], name: "index_applicants_on_job_id"
  end

  create_table "companies", charset: "latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.string "subject"
    t.text "text"
    t.string "link"
    t.string "status", default: "ACTIVE"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slack_team_id"
    t.string "slack_api_token"
    t.string "slack_webhook_url"
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "company_requests", charset: "latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "team_member_id"
    t.string "request_type"
    t.string "category"
    t.text "note"
    t.datetime "from_date"
    t.datetime "to_date"
    t.string "status", default: "PENDING"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_member_id"], name: "index_company_requests_on_team_member_id"
    t.index ["user_id"], name: "index_company_requests_on_user_id"
  end

  create_table "contents", charset: "latin1", force: :cascade do |t|
    t.string "type"
    t.bigint "company_id"
    t.string "status", default: "ACTIVE"
    t.text "content"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_contents_on_company_id"
  end

  create_table "important_links", charset: "latin1", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name", null: false
    t.text "description"
    t.string "url"
    t.string "status", default: "ACTIVE"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_important_links_on_company_id"
  end

  create_table "job_interviewers", charset: "latin1", force: :cascade do |t|
    t.bigint "job_id"
    t.bigint "team_member_id"
    t.string "status", default: "ACTIVE"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_interviewers_on_job_id"
    t.index ["team_member_id"], name: "index_job_interviewers_on_team_member_id"
  end

  create_table "jobs", charset: "latin1", force: :cascade do |t|
    t.bigint "team_id"
    t.string "title", null: false
    t.string "role", null: false
    t.text "responsibilities", null: false
    t.text "requirements"
    t.integer "compensation", default: 0, null: false
    t.text "homework_prompt"
    t.string "homework_pdf"
    t.string "applicant_requirements", null: false
    t.string "status", default: "ACTIVE"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slack_channel_id"
    t.index ["team_id"], name: "index_jobs_on_team_id"
  end

  create_table "team_member_notes", charset: "latin1", force: :cascade do |t|
    t.bigint "team_member_id"
    t.string "note_type", null: false
    t.text "description"
    t.string "scoring_matrix"
    t.string "praise"
    t.string "improvements"
    t.string "plan_name"
    t.text "core_kpis"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "reason_for_change"
    t.integer "base_comp"
    t.integer "stop_comp"
    t.datetime "effective_date"
    t.integer "manager_id"
    t.integer "team_id"
    t.string "status", default: "ACTIVE"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "title_id"
    t.index ["team_member_id"], name: "index_team_member_notes_on_team_member_id"
  end

  create_table "team_members", charset: "latin1", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "title_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email_address", null: false
    t.integer "base_comp", default: 0, null: false
    t.integer "share_stock", default: 0, null: false
    t.boolean "onboarding_email", default: false
    t.string "status", default: "ACTIVE"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_date"
    t.integer "review_schedule"
    t.string "photo_url"
    t.integer "job_title_id"
    t.index ["team_id"], name: "index_team_members_on_team_id"
    t.index ["title_id"], name: "index_team_members_on_title_id"
  end

  create_table "teams", charset: "latin1", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id"
    t.string "description"
    t.string "status", default: "ACTIVE"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_teams_on_company_id"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "titles", charset: "latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title", null: false
    t.string "description"
    t.string "status", default: "ACTIVE"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_titles_on_user_id"
  end

  create_table "user_permissions", charset: "latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "company_id"
    t.string "role"
    t.string "status", default: "ACTIVE"
    t.timestamp "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_user_permissions_on_company_id"
    t.index ["user_id"], name: "index_user_permissions_on_user_id"
  end

  create_table "users", charset: "latin1", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "photo_url"
    t.string "password_digest"
    t.string "user_type", default: "USER"
    t.string "status", default: "ACTIVE"
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.string "phone_number"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "postal_code"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "is_first_login", default: true
    t.string "emergency_first_name"
    t.string "emergency_last_name"
    t.string "emergency_email"
    t.string "emergency_phone_number"
    t.string "emergency_relationship"
    t.string "slack_channel_id"
    t.string "slack_id"
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "applicant_notes", "applicants"
  add_foreign_key "applicant_notes", "users"
  add_foreign_key "applicant_offers", "applicants"
  add_foreign_key "applicant_offers", "jobs"
  add_foreign_key "applicants", "jobs"
  add_foreign_key "companies", "users"
  add_foreign_key "company_requests", "team_members"
  add_foreign_key "company_requests", "users"
  add_foreign_key "contents", "companies"
  add_foreign_key "important_links", "companies"
  add_foreign_key "job_interviewers", "jobs"
  add_foreign_key "job_interviewers", "team_members"
  add_foreign_key "team_member_notes", "team_members"
  add_foreign_key "team_members", "teams"
  add_foreign_key "team_members", "titles"
  add_foreign_key "teams", "users"
  add_foreign_key "titles", "users"
  add_foreign_key "user_permissions", "companies"
  add_foreign_key "user_permissions", "users"
end
