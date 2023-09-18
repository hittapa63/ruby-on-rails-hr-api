class Api::V1::CompanyRequestsController < ApplicationController
    before_action :authorize_request
    before_action :find_company_request, except: %i[create index]

    def index
        @company_requests = CompanyRequest.filter_collection(filter_params).ordered
        unless @current_user.isAdmin
            team_member_ids = []
            @current_user.my_all_team_members.each do |team_member|
                team_member_ids << team_member.id
            end
            @company_requests = CompanyRequest.where(team_member_id: team_member_ids).filter_collection(filter_params).ordered
        end
        @company_requests = ActiveModelSerializers::SerializableResource.new(@company_requests, each_serializer: CompanyRequestSerializer)
        render json: { data: @company_requests, status: true }, status: :ok
    end

    def show
        @company_request = ActiveModelSerializers::SerializableResource.new(@company_request, each_serializer: CompanyRequestSerializer)
        render json: { data: @company_request, status: true}, status: :ok
    end

    def create
        @company_request = CompanyRequest.new(company_request_params)
        unless company_request_params.has_key?(:user_id)
            @company_request.user = @current_user
        end
        unless company_request_params.has_key?(:team_member_id)
            @company_request.team_member = TeamMember.where(email_address: @current_user.email).first
        end
        if @company_request.save
            render json: { data: {company_request: @company_request}, status: true}, status: :created
        else
            render json: { errors: @company_request.errors.full_messages, message: @company_request.errors.full_messages, status: false },
                    status: :ok
        end
    end

    def update
        unless @company_request.update(company_request_params)
            render json: { errors: @company_request.errors.full_messages, message: @company_request.errors.full_messages, status: false },
                    status: :ok
        end
        render json: { data: {company_request: @company_request}, message: 'Successfully updated!', status: true}, status: :ok
    end

    def destroy
        @company_request.destroy
        render json: { data: {}, message: 'Successfully deleted!', status: true}, status: :ok
    end

    private

    def find_company_request
        @company_request = CompanyRequest.find_by_id!(params[:company_request_id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Company request not found', message: 'Company request not found', status: false }, status: :ok
    end

    def company_request_params
        params.permit(
        :user_id, :team_member_id, :request_type, :category, :note, :from_date, :to_date, :status
        ).delocalize(from_date: :date, to_date: :date)
    end

    def filter_params
        params.slice(:user_id, :team_member_id, :request_type, :category, :from_date, :to_date, :status).delocalize(from_date: :date, to_date: :date)
    end
end
