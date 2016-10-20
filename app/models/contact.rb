class Contact < MailForm::Base
  attribute :name,      :validate => true
  attribute :business_name
  attribute :phone
  attribute :email,     :validate => /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  attribute :message
  attribute :type
  attribute :nickname,  :captcha  => true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "Contact from Crucendo - #{type||business_name}",
      :to => "support@thecrucialteam.com",
      :from => %("#{name}" <#{email}>)
    }
  end
end