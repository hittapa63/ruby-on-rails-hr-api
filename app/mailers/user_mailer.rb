class UserMailer < ApplicationMailer
    def reset_password(user)
        @user = user
        mail(to: user.email, subject: 'You’ve successfully enrolled in Welcome HR')
    end

    def sign_up(user)
        @user = user
        mail(to: user.email, subject: 'You’ve been added to Welcome HR')
    end
end
