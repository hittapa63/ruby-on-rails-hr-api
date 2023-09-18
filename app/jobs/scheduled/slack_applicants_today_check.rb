class Scheduled::SlackApplicantsTodayCheck < Scheduled::Base
  def perform
    Job.active.map do |job|
      @job = job
      @array_text = job.applicants.today.map do |applicant|
        "<#{FRONTEND_APPLICANTS_SHOW}/#{applicant.id} |*#{applicant.first_name} #{applicant.last_name}*>"
      end.flatten
      if @job.slack_channel_id.present?
        post_message_channel
      end
    end      
  end

  private

  def post_message_channel
    blocks = [
      SLACK_HEADER_TODAY_APPLICANTS,
      {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": "#{@array_text.join(",\n")}"
          }
      }
    ]
    data = {
      channel_name: @job.slack_channel_id,
      blocks: blocks
    }
    SlackService::Channel.call(data: data, action_name: 'post_message')
  end
end