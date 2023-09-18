class Api::V1::ApplicantNotesController < ApplicationController
    before_action :authorize_request
    before_action :find_applicant_note, except: %i[create index]

    def index
        @applicant_notes = ApplicantNote.filter_collection(filter_params).ordered
        render json: { data: {applicant_notes: @applicant_notes}, status: true }, status: :ok
    end

    def show
        render json: { data: {applicant_note: @applicant_note}, status: true}, status: :ok
    end

    def create
        @applicant_note = ApplicantNote.new(applicant_note_params)
        if @applicant_note.save
            render json: { data: {applicant_note: @applicant_note}, status: true}, status: :created
        else
            render json: { errors: @applicant_note.errors.full_messages, message: @applicant_note.errors.full_messages, status: false },
                    status: :ok
        end
    end

    def update
        unless @applicant_note.update(applicant_note_params)
            render json: { errors: @applicant_note.errors.full_messages, message: @applicant_note.errors.full_messages, status: false },
                    status: :ok
        end
        render json: { data: {applicant_note: @applicant_note}, message: 'Successfully updated!', status: true}, status: :ok
    end

    def destroy
        @applicant_note.destroy
        render json: { data: {}, message: 'Successfully deleted!', status: true}, status: :ok
    end

    private

    def find_applicant_note
        @applicant_note = ApplicantNote.find_by_id!(params[:applicant_note_id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'applicant offer not found', message: 'applicant offer not found', status: false }, status: :ok
    end

    def applicant_note_params
        params.permit(
        :applicant_id, :user_id, :note_type, :title, :description, :responsiblity_score, :growing_score, :culture_score, :hire_applicant, :homework_score, :session_score, :status
        )
    end

    def filter_params
        params.slice(:applicant_id, :user_id, :note_type, :start_date, :end_date, :status).delocalize(start_date: :date, end_date: :date)
      end
end
