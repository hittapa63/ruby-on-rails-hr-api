# frozen_string_literal: true

class Scheduled::Base < ApplicationJob
  queue_as :cron
end
