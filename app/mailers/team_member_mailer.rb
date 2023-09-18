class TeamMemberMailer < ApplicationMailer
    def report_team_member(user, team_member)
        @user = user
        @team_member = team_member
        mail(to: user.email, subject: 'Team Member Added!')
    end
end
