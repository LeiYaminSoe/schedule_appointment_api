class ScheduleAppointment < ApplicationRecord
  belongs_to :mentor
  belongs_to :student
end
