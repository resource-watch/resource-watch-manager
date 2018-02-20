# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  def contact_us_email(email, text)
    @email = email

    @text = text

    send_email(@email, ENV['CONTACT_EMAIL'], "Contact from #{@email}",
               "The email #{@email} wants to be contacted")
  end
end