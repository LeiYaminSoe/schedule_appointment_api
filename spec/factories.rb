FactoryBot.define do
  factory :mentor do
    name {"test_mentor"}
    time_zone {"-03:00"}
  end

  factory :student do
    name {"test_student"}
    time_zone {"+0900"}
  end

  factory :schedule_appointment do
    before(:create) { |object|
      object.mentor = create(:mentor)
      object.student = create(:student)
    }
    schedule_datetime {"2021-03-25 17:00:00 +0900"}
    is_allocated {"1"}
    schedule_reason {"For Another Session"}
  end
end
