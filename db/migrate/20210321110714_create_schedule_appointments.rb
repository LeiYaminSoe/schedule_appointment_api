class CreateScheduleAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :schedule_appointments do |t|
      t.belongs_to :mentor
      t.belongs_to :student
      t.string :schedule_datetime
      t.integer :is_allocated, :limit => 1, :comment => '0: available, 1:allocated'
      t.string :schedule_reason
      t.string :created_by
      t.string :updated_by
      t.string :deleted_by
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.datetime :deleted_at
    end
  end
end
