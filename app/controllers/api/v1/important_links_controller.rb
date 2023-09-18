class Api::V1::ImportantLinksController < ApplicationController
    before_action :authorize_request
    before_action :find_important_link, except: %i[create index own_important_links]

    def index
        @important_links = ImportantLink.all
        @important_links = ActiveModelSerializers::SerializableResource.new(@important_links, each_serializer: ImportantLinkSerializer)
        render json: { data: @important_links, status: true }, status: :ok
    end

    def show
        @important_link = ActiveModelSerializers::SerializableResource.new(@important_link)  
        render json: { data: @important_link, status: true}, status: :ok
    end

    def create
        @important_link = ImportantLink.new(important_link_params)
        unless important_link_params.has_key?(:company_id)
          @important_link.company = @current_user.companies.first
        end
        if @important_link.save
            @important_link = ActiveModelSerializers::SerializableResource.new(@important_link)
            render json: { data: @important_link, status: true}, status: :created
        else
            render json: { errors: @important_link.errors.full_messages, message: @important_link.errors.full_messages, status: false },
                    status: :ok
        end
    end

    def update
        unless @important_link.update(important_link_params)
            render json: { errors: @important_link.errors.full_messages, message: @important_link.errors.full_messages, status: false },
                    status: :ok
        end
        @important_link = ActiveModelSerializers::SerializableResource.new(@important_link)
        render json: { data: @important_link, message: 'Successfully updated!', status: true}, status: :ok
    end

    def destroy
        @important_link.destroy
        render json: { data: {}, message: 'Successfully deleted!', status: true}, status: :ok
    end

    def own_important_links
      @important_links = @current_user.my_all_important_links
      @important_links = @important_links.count > 0 ? ActiveModelSerializers::SerializableResource.new(@important_links, each_serializer: ImportantLinkSerializer) : { important_links: [] }
      render json: { data: @important_links, status: true }, status: :ok
    end

    private

    def find_important_link
        @important_link = ImportantLink.find_by_id!(params[:important_link_id])            
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Important Link not found', message: 'Important Link not found', status: false }, status: :ok
    end

    def important_link_params
        params.permit(
        :name, :description, :url, :company_id
        )
    end
end
