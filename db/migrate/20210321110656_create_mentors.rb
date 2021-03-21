class CreateMentors < ActiveRecord::Migration[6.1]
  def change
    create_table :mentors do |t|
      t.string :name
      t.string :time_zone
      t.string :created_by
      t.string :updated_by
      t.string :deleted_by
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.datetime :deleted_at
    end
  end
end
