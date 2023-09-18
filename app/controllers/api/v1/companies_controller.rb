class Api::V1::CompaniesController < ApplicationController
    before_action :authorize_request
    before_action :find_company, except: %i[create index own_companies]

    def index
        @companies = Company.all
        @companies = ActiveModelSerializers::SerializableResource.new(@companies)
        render json: { data: @companies, status: true }, status: :ok
    end

    def show
        @company = ActiveModelSerializers::SerializableResource.new(@company)
        render json: { data: @company, status: true}, status: :ok
    end

    def create
        @company = Company.new(company_params)
        unless company_params.has_key?(:user_id)
          @company.user = @current_user
        end
        if @company.save
            @company = ActiveModelSerializers::SerializableResource.new(@company)
            render json: { data: @company, status: true}, status: :created
        else
            render json: { errors: @company.errors.full_messages, message: @company.errors.full_messages, status: false },
                    status: :ok
        end
    end

    def update
        unless @company.update(company_params)
            render json: { errors: @company.errors.full_messages, message: @company.errors.full_messages, status: false },
                    status: :ok
        end
        @company = ActiveModelSerializers::SerializableResource.new(@company)
        render json: { data: @company, message: 'Successfully updated!', status: true}, status: :ok
    end

    def destroy
        @company.destroy
        render json: { data: {}, message: 'Successfully deleted!', status: true}, status: :ok
    end

    def own_companies
      @companies = @current_user.companies
      member_companies = @current_user.companies_as_member
      if (member_companies.count > 0)
        @companies += member_companies
      end
      @companies = ActiveModelSerializers::SerializableResource.new(@companies)
      render json: { data:  @companies, status: true }, status: :ok
    end

    private

    def find_company
        @company = Company.find_by_id!(params[:company_id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Company not found', message: 'Company not found', status: false }, status: :ok
    end

    def company_params
        params.permit(
        :name, :subject, :text, :link, :status, :user_id
        )
    end
end
