User.create!(name:  "Tristan",
             email: "tristan@thecrucialteam.com",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(name:  "Brett",
             email: "brett@thecrucialteam.com",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)
             
Category.create!(name: "Encouraging")
Category.create!(name: "Challenging")
Category.create!(name: "Digesting")
Category.create!(name: "Bonus")