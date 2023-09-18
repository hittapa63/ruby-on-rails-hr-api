class Scheduled::SlackGetUsersList < Scheduled::Base
  def perform
    puts "🧵🧵🧵🧵🧵 slack get user list 🧵🧵🧵🧵🧵"
    members = SlackService::User.call(data: nil, action_name: 'users_list')
    members.each do |member|
      @member = member
      if member.profile.email.present?
        check_user
      end
    end 
  end

  private

  def check_user
    puts "🧵🧵🧵🧵🧵 slack get user list check user 🧵🧵🧵🧵🧵"
    puts @member.profile.email
    puts @member.id
    user = User.find_by_email(@member.profile.email)
    if user.present?
      user.slack_id = @member.id
      data = {
        users: @member.id
      }
      channel = SlackService::User.call(data: data, action_name: 'users_conversation_open')
      if channel.present? && channel.id.present?
        user.slack_channel_id = channel.id
      end
      if user.photo_url.blank?
        user.photo_url = @member.profile.image_512
      end
      user.save
      # data = {
      #   channel_name: "##{HR_CHANNEL}, ##{GENERAL_CHANNEL}",
      #   user: user
      # }
      # SlackService::Channel.call(data: data, action_name: 'channel_add_user')
    end
  end
end