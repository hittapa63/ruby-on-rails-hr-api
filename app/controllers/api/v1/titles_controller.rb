class Api::V1::TitlesController < ApplicationController
    before_action :authorize_request
    before_action :find_title, except: %i[create index own_titles]

    def index
        @titles = Title.all
        render json: { data: {titles: @titles}, status: true }, status: :ok
    end

    def show
        render json: { data: {title: @title}, status: true}, status: :ok
    end

    def create
        @title = Title.new(title_params)
        unless title_params.has_key?(:user_id)
          @title.user = @current_user
        end
        if @title.save
            render json: { data: {title: @title}, status: true}, status: :created
        else
            render json: { errors: @title.errors.full_messages, message: @title.errors.full_messages, status: false },
                    status: :ok
        end
    end

    def update
        unless @title.update(title_params)
            render json: { errors: @title.errors.full_messages, message: @title.errors.full_messages, status: false },
                    status: :ok
        end
        render json: { data: {title: @title}, message: 'Successfully updated!', status: true}, status: :ok
    end

    def destroy
        @title.destroy
        render json: { data: {}, message: 'Successfully deleted!', status: true}, status: :ok
    end

    def own_titles
      @titles = @current_user.titles
      render json: { data: {titles: @titles}, status: true }, status: :ok
    end

    private

    def find_title
        @title = Title.find_by_id!(params[:title_id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Title not found', message: 'Title not found', status: false }, status: :ok
    end

    def title_params
        params.permit(
        :title, :description, :status, :user_id
        )
    end
end
