FRONTEND_URL = "#{ENV['FRONTEND_URL']}"
FRONTEND_HR_MEETINGS_SHOW = "#{FRONTEND_URL}/admin/hr-meetings"
FRONTEND_APPLICANTS_SHOW = "#{FRONTEND_URL}/recruiting/applicants/show"
HR_CHANNEL = "hr-channel"
GENERAL_CHANNEL = "general"
SLACK_HEADER_COMPANY_UPDATE = {
    "type": "header",
    "text": {
        "type": "plain_text",
        "text": "Company Update",
        "emoji": true
    }
}
SLACK_HEADER_ENROLL = {
    "type": "header",
    "text": {
        "type": "plain_text",
        "text": "Enroll",
        "emoji": true
    }
}
SLACK_HEADER_NEW_USER = {
    "type": "header",
    "text": {
        "type": "plain_text",
        "text": "New User",
        "emoji": true
    }
}
SLACK_HEADER_HR_MEETING = {
    "type": "header",
    "text": {
        "type": "plain_text",
        "text": "New HR meeting",
        "emoji": true
    }
}
SLACK_HEADER_HR_NOTE = {
    "type": "header",
    "text": {
        "type": "plain_text",
        "text": "HR Note",
        "emoji": true
    }
}
SLACK_HEADER_TODAY_APPLICANTS = {
    "type": "header",
    "text": {
      "type": "plain_text",
      "text": "Today's Applicants",
      "emoji": true
    }
}
SLACK_HEADER_TODAY_TIME_OFF_REQUEST = {
    "type": "header",
    "text": {
        "type": "plain_text",
        "text": "Time Off Request",
        "emoji": true
    }
}
SLACK_HEADER_TODAY_APPLICANT_STATUS_CHANGES = {
    "type": "header",
    "text": {
      "type": "plain_text",
      "text": "Today's Applicant status changes",
      "emoji": true
    }
}
SLACK_HEADER_NEXT_REVIEW_COMING = {
    "type": "header",
    "text": {
      "type": "plain_text",
      "text": "Next Review",
      "emoji": true
    }
}