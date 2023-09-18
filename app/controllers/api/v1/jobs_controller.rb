class Api::V1::JobsController < ApplicationController
    before_action :authorize_request, except: %i[show]
    before_action :find_job, except: %i[create index own_jobs]

    def index
        @jobs = Job.all
        render json: { data: {jobs: @jobs}, status: true }, status: :ok
    end

    def show
        render json: { data: {job: JobSerializer.new(@job)}, status: true}, status: :ok
    end

    def create
        @job = Job.new(job_params)
        if @job.save
            render json: { data: {job: @job}, status: true}, status: :created
            JobMailer.create_job(@job, @current_user).deliver_now
        else
            render json: { errors: @job.errors.full_messages, message: @job.errors.full_messages, status: false },
                    status: :ok
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

    def own_jobs
        order_by = params[:order_by].present? ? params[:order_by] : 'id'
        order_priority = params[:order].present? ? params[:order] : 'DESC'
        order = "#{order_by} #{order_priority}"
        page = params[:page].present? ? params[:page] : 1
        per_page = params[:per_page].present? ? params[:per_page] : 0
        team_ids = []
        @current_user.my_all_teams.each do |team|
            team_ids << team.id
        end
        jobs = Job.where(team_id: team_ids).filter_collection(filter_params).order(order)
        if (per_page.to_i > 0) 
            @jobs = jobs.paginate(page: page, per_page: per_page)
            paginate = { total_count: jobs.count, page: page, per_page: per_page}
            @jobs = ActiveModelSerializers::SerializableResource.new(@jobs)
        else 
            @jobs = jobs
            paginate = { total_count: jobs.count, page: page, per_page: per_page}
            @jobs = ActiveModelSerializers::SerializableResource.new(@jobs)
        end
        
        render json: { data: @jobs, paginate: paginate, status: true }, status: :ok
    end

    private

    def find_job
        @job = Job.find_by_id!(params[:job_id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'job not found', message: 'job not found', status: false }, status: :ok
    end

    def job_params
        params.permit(
        :team_id, :title, :role, :responsibilities, :requirements, :compensation, :homework_prompt, :homework_pdf, :applicant_requirements, :status
        )
    end

    def filter_params
        params.slice(:status, :role)
      end
end
