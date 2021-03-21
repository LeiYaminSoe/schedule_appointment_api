require 'rails_helper'

RSpec.describe "ScheduleAppointment", :type => :request do
  before do
    mentor = create(:mentor)
    student = create(:student)
  end

  it 'get display_appointment' do
    get '/api/v1/schedule_appointment/display_appointment?date=2021-05-02'
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(json['mentor']['name']).to eq("Max Mustermann")
    expect(json['available_slot'].length).to eq(22)
    expect(json['allocated_slot'].length).to eq(2)
  end

  it 'display_appointment for no datetime data from third party API' do
    schedule_appointment = create(:schedule_appointment)
    get '/api/v1/schedule_appointment/display_appointment?date=2019-04-11'
    json = JSON.parse(response.body)

    expect(response.status).to eq(404)
    expect(json['message']).to eq("No Data Available")
  end

  it 'display_appointment with no date param' do
    schedule_appointment = create(:schedule_appointment)
    get '/api/v1/schedule_appointment/display_appointment?'
    json = JSON.parse(response.body)

    expect(response.status).to eq(404)
    expect(json['message']).to eq("No Data Available")
  end

  it 'display_appointment with incomplete url' do
    schedule_appointment = create(:schedule_appointment)
    get '/api/v1/schedule_appointment/display_appointment?date=2019-'
    json = JSON.parse(response.body)

    expect(response.status).to eq(404)
    expect(json['message']).to eq("No Data Available")
  end

  it 'page not found' do
    schedule_appointment = create(:schedule_appointment)
    get '/api/v1/schedule_appointment/display_a'
    json = JSON.parse(response.body)

    expect(json['message']).to eq("Page Not Found")
  end

  it 'get book_appointment' do
    get '/api/v1/schedule_appointment/book_appointment?desired_date_time=2021-05-02 16:00:00&reason=For Another Session'
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(json['date']).to eq("2021-05-02")
    expect(json['time']).to eq("16:00:00")
    expect(json['reason']).to eq("For Another Session")
  end

  it 'book_appointment for already available slot' do
    schedule_appointment = create(:schedule_appointment)
    get '/api/v1/schedule_appointment/book_appointment?desired_date_time=2021-03-25 17:00:00&reason=For Another Session'
    json = JSON.parse(response.body)

    expect(json['message']).to eq("This time slot is already allocated. Please choose other time slot.")
  end

  it 'book_appointment for already available slot with middle time' do
    schedule_appointment = create(:schedule_appointment)
    get '/api/v1/schedule_appointment/book_appointment?desired_date_time=2021-03-25 17:33:15&reason=For Another Session'
    json = JSON.parse(response.body)

    expect(json['message']).to eq("This time slot is already allocated. Please choose other time slot.")
  end

  it 'book_appointment with bad param' do
    schedule_appointment = create(:schedule_appointment)
    get '/api/v1/schedule_appointment/book_appointment?desired_date_time=2021-025 170:00&reason=For Another Session'
    json = JSON.parse(response.body)

    expect(response.status).to eq(404)
    expect(json['message']).to eq("No Data Available")
  end
end
