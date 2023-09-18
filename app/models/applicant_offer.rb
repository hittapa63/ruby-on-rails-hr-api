class ApplicantOffer < ApplicationRecord
    include Filterable

    belongs_to :applicant
end
