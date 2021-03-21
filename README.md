# README

*How I Approach
1.	I thought it has to be two methods, a. to display all available and already allocated date_time b. to book for my appointment
2.	If Allocated date_time from API show as "2021-04-11 11:39:45 +0900", I consider as start_datetime "2021-04-11 11:00:00 +0900" from end_datetime "2021-04-11 12:00:00 +0900"
3.	I mainly focus on student time_zone so I change date_time according to student.
4.  I have the structure with api/v1 for version control of API and service layer for API call. I might need to add API secret key etc if requirement change.
5.  I add rack_attack to limit API request throttling(May be useful in future.) Right now, 10,000 request per day can make to third party API(CF_calendar).

*Design

1. I choose to have <b>Mentor(One) and ScheduleAppointment(Many)</b> and <b>Student(One) and ScheduleAppointment(Many)</b> relationship. In order to keep track of schedule appointment from student and to know about mentor.
2. In future, I might have <b>Mentor(Many) and Student(Many)</b> relationship too.
3. In order to keep it simple, I choose to have a <b>flag for is_allocated</b>. 
4. Right now, data from third party API could change anytime so I delete existing db data after I call API and add updated data again.
5. <b>When student book available slot, I updated is_allocated flag to 1.</b>

*Specification

Ruby => 3.0.0

Rails => 6.1.3

DB => postgresql

*How to Run
1. Create, migrate and seed database
 
    <b>rails db:migrate
  
      rails db:seed</b>
2. Run Server
 
    <b>rails server</b>

*How to Run Test Cases

bundle exec rspec spec/requests/api/v1/schedule_appointments_spec.rb

*How to Test API request Throttling

In config/initializers/rack_attack.rb file, 

add comment '#' in front of "throttle('req/ip', :limit => 10000, :period => 24.hours) do |req|"

remove comment "#" in front of "throttle('req/ip', :limit => 2, :period => 24.hours) do |req|"

By this way, you can only call twice per day to third party API(CF_calendar)

*How to Test from website url after running <b>rails server</b>

<b>it is the data I got from API as of 22.3.2021</b>

url and its likely outcome

1. http://localhost:3000/api/v1/schedule_appointment/display_appointment?date=2021-04-11

{"mentor":{"name":"Max Mustermann","time_zone":"-03:00"},"available_slot":[{"date_time":"2021-04-11 00:00:00 +0900"},{"date_time":"2021-04-11 01:00:00 +0900"},{"date_time":"2021-04-11 02:00:00 +0900"},{"date_time":"2021-04-11 03:00:00 +0900"},{"date_time":"2021-04-11 04:00:00 +0900"},{"date_time":"2021-04-11 05:00:00 +0900"},{"date_time":"2021-04-11 06:00:00 +0900"},{"date_time":"2021-04-11 07:00:00 +0900"},{"date_time":"2021-04-11 08:00:00 +0900"},{"date_time":"2021-04-11 09:00:00 +0900"},{"date_time":"2021-04-11 10:00:00 +0900"},{"date_time":"2021-04-11 11:00:00 +0900"},{"date_time":"2021-04-11 13:00:00 +0900"},{"date_time":"2021-04-11 14:00:00 +0900"},{"date_time":"2021-04-11 15:00:00 +0900"},{"date_time":"2021-04-11 16:00:00 +0900"},{"date_time":"2021-04-11 17:00:00 +0900"},{"date_time":"2021-04-11 18:00:00 +0900"},{"date_time":"2021-04-11 19:00:00 +0900"},{"date_time":"2021-04-11 21:00:00 +0900"},{"date_time":"2021-04-11 22:00:00 +0900"},{"date_time":"2021-04-11 23:00:00 +0900"}],"allocated_slot":[{"date_time":"2021-04-11 12:00:00 +0900"},{"date_time":"2021-04-11 20:00:00 +0900"}]}

2. http://localhost:3000/api/v1/schedule_appointment/display_appointment?

{"status":404,"message":"No Data Available"}

3. http://localhost:3000/api/v1/schedule_appointment/display_appointment?date=2019-04-11

{"status":404,"message":"No Data Available"}

4. http://localhost:3000/api/v1/schedule_appointment/display_appointment?date=2019-

{"status":404,"message":"No Data Available"}

5. http://localhost:3000/api/v1/schedule_appointment/display_a

{"status":404,"message":"Page Not Found"}

6. http://localhost:3000/api/v1/schedule_appointment/book_appointment?desired_date_time=2021-03-26 10:00:00&reason=For Third Lesson

{"status":204,"message":"This time slot is already allocated. Please choose other time slot."}

7. http://localhost:3000/api/v1/schedule_appointment/book_appointment?desired_date_time=2021-03-26 10:33:11&reason=For Third Lesson

{"status":204,"message":"This time slot is already allocated. Please choose other time slot."}

8. http://localhost:3000/api/v1/schedule_appointment/book_appointment?desired_date_time=2021-03-26 16:00:00&reason=For Another Session

{"date":"2021-03-26","time":"16:00:00","reason":"For Another Session"}

9. http://localhost:3000/api/v1/schedule_appointment/book_appointment?desired_date_time=2021-03-26 16:00:00&reason=For Third Lesson

{"status":204,"message":"This time slot is already allocated. Please choose other time slot."}

10. http://localhost:3000/api/v1/schedule_appointment/book_appointment?desired_date_time=2021-026 16:00:00&reason=For Third Lesson

{"status":404,"message":"No Data Available"}

