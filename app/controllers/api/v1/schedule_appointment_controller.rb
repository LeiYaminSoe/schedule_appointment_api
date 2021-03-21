class Api::V1::ScheduleAppointmentController < ApplicationController

  def display_appointment
    if params[:date]
      api_response = CfCalendar::Search.get_data
      if api_response.present?
        if api_response.body.present?
          api_response_body = JSON.parse(api_response.body)
          if api_response_body.present?
            @response = display_all_schedule(api_response_body, params[:date])
            if !@response.empty?
              render json: @response and return
            end
          end
        end
      end
    end
    render json: { status: 404, message: 'No Data Available' }, status: 404
  end

  def book_appointment
    @confirmed_appointment = Hash.new
    if params[:desired_date_time].present? && params[:reason].present?
      desired_date_time = params[:desired_date_time].to_s + " +0900"
      @schedule_appointments = ScheduleAppointment.where(:schedule_datetime => desired_date_time)
      if @schedule_appointments.present?
        if @schedule_appointments.first.is_allocated == 1
          render json: { status: 204, message: 'This time slot is already allocated. Please choose other time slot.' } and return
        else
          @schedule_appointments.first.is_allocated = 1
          @schedule_appointments.first.schedule_reason = params[:reason]
          if @schedule_appointments.first.save
            @confirmed_appointment["date"] = @schedule_appointments.first.schedule_datetime.split(" ")[0]
            @confirmed_appointment["time"] = @schedule_appointments.first.schedule_datetime.split(" ")[1]
            @confirmed_appointment["reason"] = @schedule_appointments.first.schedule_reason
            render json: @confirmed_appointment and return
          end
        end
      else
        if valid_date?(desired_date_time)
          @schedule_appointment = ScheduleAppointment.new(:schedule_datetime => desired_date_time, :is_allocated => 1, :schedule_reason => params[:reason])
          @schedule_appointment.student = Student.all.first
          @schedule_appointment.mentor = Mentor.all.first
          if @schedule_appointment.save
            @confirmed_appointment["date"] = @schedule_appointment.schedule_datetime.split(" ")[0]
            @confirmed_appointment["time"] = @schedule_appointment.schedule_datetime.split(" ")[1]
            @confirmed_appointment["reason"] = @schedule_appointment.schedule_reason
            render json: @confirmed_appointment and return
          end
        end
      end
    end
    render json: { status: 404, message: 'No Data Available' }, status: 404
  end

  def display_all_schedule(response, desired_date)
    schedule_info_arr = Array.new
    available_slot_arr = Array.new
    allocated_slot_arr = Array.new
    schedule_info_hash = Hash.new
    mentor_hash = Hash.new

    response["calendar"].map do |schedule|
      schedule_date = DateTime.strptime(schedule["date_time"], '%Y-%m-%d').to_date.to_s
      if schedule_date == desired_date
        allocated_datetime = DateTime.strptime(schedule["date_time"], '%Y-%m-%d %H:%M:%S %z').in_time_zone('Tokyo').change({min: 0, sec: 0}).to_s
        unless allocated_datetime.to_date > desired_date.to_date || allocated_datetime.to_date < desired_date.to_date
          allocated_slot_arr << {"date_time"=>allocated_datetime}
        end
      end
    end
    if !allocated_slot_arr.empty?
      datetime_list_arr = get_all_time(desired_date)
      schedule_info_hash["mentor"] = response["mentor"]
      available_slot_arr = datetime_list_arr - allocated_slot_arr
      schedule_info_hash["available_slot"] = available_slot_arr
      schedule_info_hash["allocated_slot"] = allocated_slot_arr
      @mentor = Mentor.where(:name => response["mentor"]["name"])
      if @mentor.blank?
        @mentor = Mentor.new(:name => response["mentor"]["name"], :time_zone => response["mentor"]["time_zone"])
        @mentor.save
      end
      @mentor = Mentor.where(:name => response["mentor"]["name"])
      @existing_schedule = ScheduleAppointment.where("schedule_datetime LIKE ? ", "%#{desired_date}%")
      ScheduleAppointment.delete(@existing_schedule.ids)

      available_slot_arr.each do |datetime|
        @available_slot = ScheduleAppointment.new(:schedule_datetime => datetime["date_time"], :is_allocated => 0)
        @available_slot.student = Student.all.first
        @available_slot.mentor = Mentor.find(@mentor.first.id)
        @available_slot.save
      end
      allocated_slot_arr.each do |datetime|
        @allocated_slot = ScheduleAppointment.new(:schedule_datetime => datetime["date_time"], :is_allocated => 1)
        @allocated_slot.student = Student.all.first
        @allocated_slot.mentor = Mentor.find(@mentor.first.id)
        @allocated_slot.save
      end
    end
    return schedule_info_hash
  end

  def get_all_time(desired_date)
    datetime_list_arr = Array.new
    (0..23).each do |index|
      datetime_hash = Hash.new
      if index <10
        datetime_hash["date_time"] = desired_date + " 0" + index.to_s + ":00:00 +0900"
      else
        datetime_hash["date_time"] = desired_date + " " + index.to_s + ":00:00 +0900"
      end
      datetime_list_arr << datetime_hash
    end
    return datetime_list_arr
  end

  def valid_date?(date)
    date_format = '%Y-%m-%d'
    DateTime.strptime(date, date_format)
      true
    rescue ArgumentError
      false
  end
end
