# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  def contact_us_email(email, text, topic)
    @email = email

    @text = text

    send_email(email, ENV['CONTACT_EMAIL'], text, topic)
  end
end
