# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  def contact_us_email(email, text)
    @email = email

    @text = text

    mail(to: ENV['CONTACT_EMAIL'], subject: "Contact from #{email}")
  end
end
