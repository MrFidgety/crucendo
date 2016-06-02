User.create!(name:  "Example User",
             email: "example@thecrucialteam.com",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@thecrucialteam.com"
  User.create!(name:  name,
              email: email,
              activated: true,
              activated_at: Time.zone.now)
end