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
             
QuestionCategory.create!(name: "Encouraging")
QuestionCategory.create!(name: "Challenging")
QuestionCategory.create!(name: "Digesting")
QuestionCategory.create!(name: "Bonus")