class SendSlackNotificationJob < ApplicationJob
  include HTTParty
  queue_as :default

  def perform(message)
    return unless ENV['SLACK_WEBHOOK_URL'].present?
  
    HTTParty.post(
      ENV['SLACK_WEBHOOK_URL'],
      body: {
        message: message
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  # SendSlackNotificationJob.perform_later("hello")
end
