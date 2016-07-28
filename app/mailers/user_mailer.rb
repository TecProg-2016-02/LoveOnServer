class UserMailer < ActionMailer::Base

  def password_reset(user)
    @user = user
    mail( :to => user.email,
          :from => 'LoveOnApp?',
          :subject => 'Redefinição de senha')
  end

  def registration_confirmation(user)
    @user = user
    mail( :to => user.email,
          :from => 'LoveOnApp?',
          :subject => 'Ativar conta')
  end

end
