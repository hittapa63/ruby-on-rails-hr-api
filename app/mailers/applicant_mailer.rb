class ApplicantMailer < ApplicationMailer
    def applicant_reject(applicant)
        @applicant = applicant
        mail(to: applicant.email, subject: 'Role at Welcome Homes')
    end
end
