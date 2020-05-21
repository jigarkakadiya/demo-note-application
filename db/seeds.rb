# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create!(email: "test@user.com", password: "password", name: "Test user", contact: "1234567891", confirmed_at: Date.today, password_confirmation: "password")
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
Permission.create!(name: 'Read Only')
Permission.create!(name: 'Edit')
Permission.create!(name: 'Owner')
