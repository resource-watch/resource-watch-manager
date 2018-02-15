class ContactMailer < ApplicationMailer
  def contact_us_email(email, text)
    @email = email

    @text = text

    mail(to: ENV['CONTACT_EMAIL'], from: @email, subject: "Contact from #{@email}")
  end
end