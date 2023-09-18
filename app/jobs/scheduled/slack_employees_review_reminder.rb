class Scheduled::SlackEmployeesReviewReminder < Scheduled::Base
  def perform
    TeamMember.active.map do |member|
      if member.reviewIsIn2Weeks
        @weeks = "2 weeks"
        @member = member
        send_message
      end
      if member.reviewIsInWeek
        @weeks = "this week"
        send_message
      end
    end     
  end

  private

  def send_message
    @channel = @member.team.user.slack_channel_id
    @text = "#{@member.first_name} #{@member.last_name}'s next review is coming up in #{@weeks}. Please schedule a review meeting."
    post_message_channel
    @channel = "##{HR_CHANNEL}"
    @text = "#{@member.first_name} #{@member.last_name}'s next review is coming up in #{@weeks}. #{@member.team.user.name} has been notified."
    post_message_channel
  end

  def post_message_channel
    blocks = [
      SLACK_HEADER_NEXT_REVIEW_COMING,
      {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": "#{@text}"
          }
      }
    ]
    data = {
      channel_name: @channel,
      blocks: blocks
    }
    if @channel.present?
      SlackService::Channel.call(data: data, action_name: 'post_message')
    end      
  end
end