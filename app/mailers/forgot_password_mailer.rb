class ForgotPasswordMailer < ApplicationMailer
    def forgot_password(user)
        @user = user
        mail(to: user.email, subject: 'Password Forgot')
    end
end
