module CfCalendar
  class Search
    def self.get_data
      Faraday.get 'https://private-37dacc-cfcalendar.apiary-mock.com/mentors/1/agenda'
    end
  end
end
