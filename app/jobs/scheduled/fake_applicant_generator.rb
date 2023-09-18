class Scheduled::FakeApplicantGenerator < Scheduled::Base
  def perform
    source_types = ["LINKEDIN", "FACEBOOK", "DIRECT", "INDEED"]
    Job.all.each do |job|
      10.times do |index|
        Applicant.create!(
          job_id: job.id,
          source_url: Faker::Internet.url,
          source_type: source_types[rand(0..3)],
          portfolio: Faker::Internet.url,
          resume: Faker::Internet.url,
          cover: Faker::Lorem.paragraph,
          first_name: Faker::Name.first_name,
          middle_name: Faker::Name.name_with_middle.split(' ')[1],
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email
        )
      end
    end
  end
end