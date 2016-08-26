class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  default from: "Crucendo <noreply@thecrucialteam.com>"
  layout 'mailer'
end
