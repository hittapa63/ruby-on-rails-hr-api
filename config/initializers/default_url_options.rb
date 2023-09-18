# frozen_string_literal: true

protocol = Rails.application.config.force_ssl ? 'https' : 'http'
port = ENV['APP_PORT'].presence || (protocol == 'https' ? 443 : 80)

Rails.application.routes.default_url_options.merge!(
  host: ENV['APP_HOST'],
  port: port,
  protocol: protocol
)
