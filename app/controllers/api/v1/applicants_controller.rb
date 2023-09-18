class Api::V1::ApplicantsController < ApplicationController
    before_action :authorize_request, except: %i[create index]
    before_action :find_applicant, except: %i[create index own_applicants]

    def index
        @applicants = Applicant.all
        render json: { data: {applicants: @applicants}, status: true }, status: :ok
    end

    def show
        render json: { data: {applicant: @applicant}, status: true}, status: :ok
    end

    def create
        @applicant = Applicant.new(applicant_params)
        if @applicant.save
            render json: { data: {applicant: @applicant}, status: true}, status: :created
        else
            render json: { errors: @applicant.errors.full_messages, message: @applicant.errors.full_messages, status: false },
                    status: :ok
        end
    end

    def update
        unless @applicant.update(applicant_params)
            render json: { errors: @applicant.errors.full_messages, message: @applicant.errors.full_messages, status: false },
                    status: :ok
        end
        render json: { data: {applicant: @applicant}, message: 'Successfully updated!', status: true}, status: :ok
    end

    def destroy
        @applicant.destroy
        render json: { data: {}, message: 'Successfully deleted!', status: true}, status: :ok
    end

    def own_applicants
        order_by = params[:order_by].present? ? params[:order_by] : 'id'
        order_priority = params[:order].present? ? params[:order] : 'DESC'
        order = "#{order_by} #{order_priority}"
        page = params[:page].present? ? params[:page] : 1
        per_page = params[:per_page].present? ? params[:per_page] : 0
        job_ids = []
        if params[:job_id].present?
            job_ids << params[:job_id]
        else
            @current_user.my_all_jobs.each do |job|
                job_ids << job.id
            end
        end            
        applicants = Applicant.where(job_id: job_ids).filter_collection(filter_params).order(order)
        if per_page.to_i > 0
            @applicants = applicants.paginate(page: page, per_page: per_page)
        else
            @applicants = applicants
        end
        
        paginate = { total_count: applicants.count, page: page, per_page: per_page}
        render json: { data: {applicants: @applicants}, paginate: paginate, status: true }, status: :ok
    end

    private

    def find_applicant
        @applicant = Applicant.find_by_id!(params[:applicant_id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'applicant not found', message: 'applicant not found', status: false }, status: :ok
    end

    def applicant_params
        params.permit(
        :job_id, :source_url, :source_type, :portfolio, :resume, :cover, :first_name, :middle_name, :last_name, :email, :status, :stage, :rejected_reason, :rejected_text
        )
    end

    def filter_params
        params.slice(:stage, :source_type, :start_date, :end_date).delocalize(start_date: :date, end_date: :date)
      end
end
