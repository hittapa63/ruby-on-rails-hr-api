class Api::V1::ApplicantOffersController < ApplicationController
    before_action :authorize_request
    before_action :find_applicant_offer, except: %i[create index]

    def index
        @applicant_offers = ApplicantOffer.all
        render json: { data: {applicant_offers: @applicant_offers}, status: true }, status: :ok
    end

    def show
        render json: { data: {applicant_offer: @applicant_offer}, status: true}, status: :ok
    end

    def create
        @applicant_offer = ApplicantOffer.new(applicant_offer_params)
        if @applicant_offer.save
            render json: { data: {applicant_offer: @applicant_offer}, status: true}, status: :created
        else
            render json: { errors: @applicant_offer.errors.full_messages, message: @applicant_offer.errors.full_messages, status: false },
                    status: :ok
        end
    end

    def update
        unless @applicant_offer.update(applicant_offer_params)
            render json: { errors: @applicant_offer.errors.full_messages, message: @applicant_offer.errors.full_messages, status: false },
                    status: :ok
        end
        render json: { data: {applicant_offer: @applicant_offer}, message: 'Successfully updated!', status: true}, status: :ok
    end

    def destroy
        @applicant_offer.destroy
        render json: { data: {}, message: 'Successfully deleted!', status: true}, status: :ok
    end

    private

    def find_applicant_offer
        @applicant_offer = ApplicantOffer.find_by_id!(params[:applicant_offer_id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'applicant offer not found', message: 'applicant offer not found', status: false }, status: :ok
    end

    def applicant_offer_params
        params.permit(
        :applicant_id, :job_id, :first_name, :last_name, :title, :base_salary, :share_stock, :valid_until_date, :valid_start_date, :status
        ).delocalize(valid_until_date: :date, valid_start_date: :date)
    end
end
