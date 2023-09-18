class Api::V1::JobInterviewersController < ApplicationController
    before_action :authorize_request
    before_action :find_job_interviewer, except: %i[create index]

    def index
        @job_interviewers = JobInterviewer.all
        render json: { data: {job_interviewers: @job_interviewers}, status: true }, status: :ok
    end

    def show
        render json: { data: {job_interviewer: @job_interviewer}, status: true}, status: :ok
    end

    def create
        @job_interviewer = JobInterviewer.new(job_interviewer_params)
        if @job_interviewer.save
            render json: { data: {job_interviewer: @job_interviewer}, status: true}, status: :created
        else
            render json: { errors: @job_interviewer.errors.full_messages, message: @job_interviewer.errors.full_messages, status: false },
                    status: :ok
        end
    end

    def update
        unless @job_interviewer.update(job_interviewer_params)
            render json: { errors: @job_interviewer.errors.full_messages, message: @job_interviewer.errors.full_messages, status: false },
                    status: :ok
        end
        render json: { data: {job_interviewer: @job_interviewer}, message: 'Successfully updated!', status: true}, status: :ok
    end

    def destroy
        @job_interviewer.destroy
        render json: { data: {}, message: 'Successfully deleted!', status: true}, status: :ok
    end

    private

    def find_job_interviewer
        @job_interviewer = JobInterviewer.find_by_id!(params[:job_interviewer_id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'job interviewer not found', message: 'job interviewer not found', status: false }, status: :ok
    end

    def job_interviewer_params
        params.permit(
            :job_id, :team_member_id, :status
        )
    end
end
