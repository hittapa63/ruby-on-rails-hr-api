class Api::V1::ContentsController < ApplicationController
    def query_contents
        company_id = params[:company_id]
        type = params[:type]
        @contents = Content.where(company_id: company_id).where(type: type)
        render json: { data: {contents: @contents}, status: true }, status: :ok
    end

    private

    def important_link_params
        params.permit(
        :name, :description, :url, :company_id
        )
    end
end
