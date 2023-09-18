class Api::V1::StorageController < ApplicationController
    before_action :find_storage, except: %i[create index]

    def index
        @jobs = Job.all
        render json: { data: {jobs: @jobs}, status: true }, status: :ok
    end

    def show
        render json: { data: {job: JobSerializer.new(@job)}, status: true}, status: :ok
    end

    def create
       file = params[:file]
       if file.present?
        filename = file.original_filename
        blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename)
        render json: { data: {blob: blob, url: rails_representation_url(blob)}, status: true }, status: :ok
       else
        render json: { message: "Failed Upload!", status: false }, status: :ok
       end
    end

    def update
        unless @job.update(job_params)
            render json: { errors: @job.errors.full_messages, message: @job.errors.full_messages, status: false },
                    status: :ok
        end
        render json: { data: {job: @job}, message: 'Successfully updated!', status: true}, status: :ok
    end

    def destroy
        @job.destroy
        render json: { data: {}, message: 'Successfully deleted!', status: true}, status: :ok
    end

    private

    def find_storage
        @job = Job.find_by_id!(params[:job_id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'job not found', message: 'job not found', status: false }, status: :ok
    end
end
