# HR APIs

## technical stack
- latest ruby on rails
- SideKiq and schedule
- Slack notification (via webhook)
- Sendgrid
- AWS S3
- AWS Elastic BeanStack/EC2

## configuration with your environment values
- create .env file and copy data from .env.example
- set keys and values with yours

## Installation
```bash
bundle install
rake db:migrate
rails s
bundle exec sidekiq -C config/sidekiq.yml
```
