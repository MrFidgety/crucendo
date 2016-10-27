class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  default from: "Crucendo <crucendo@thecrucialteam.com>"
  layout 'mailer'
end
