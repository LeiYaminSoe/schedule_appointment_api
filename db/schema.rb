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

ActiveRecord::Schema.define(version: 2021_03_21_110714) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mentors", force: :cascade do |t|
    t.string "name"
    t.string "time_zone"
    t.string "created_by"
    t.string "updated_by"
    t.string "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "schedule_appointments", force: :cascade do |t|
    t.bigint "mentor_id"
    t.bigint "student_id"
    t.string "schedule_datetime"
    t.integer "is_allocated", limit: 2, comment: "0: available, 1:allocated"
    t.string "schedule_reason"
    t.string "created_by"
    t.string "updated_by"
    t.string "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["mentor_id"], name: "index_schedule_appointments_on_mentor_id"
    t.index ["student_id"], name: "index_schedule_appointments_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "time_zone"
    t.string "created_by"
    t.string "updated_by"
    t.string "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

end
