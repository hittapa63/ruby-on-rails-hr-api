class JobMailer < ApplicationMailer
    def create_job(job, user)
        @user = user
        @job = job
        mail(to: user.email, subject: 'You’ve successfully created a new job in Welcome HR')
    end
end
