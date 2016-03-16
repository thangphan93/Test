class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    mail to: @user.email, subject: "Velkommen!"
  end

  def change_pw_confirmed(user)
    @user = user
    mail to: @user.email, subject: "Password changed successfully! :)"
  end
end
