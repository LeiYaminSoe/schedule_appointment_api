# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Student.create! do |s|
  s.name = 'New Student'
  s.time_zone = '+0900'
  s.created_by = 1
  s.updated_by = 1
  s.created_at = Time.now()
  s.updated_at = Time.now()
end
