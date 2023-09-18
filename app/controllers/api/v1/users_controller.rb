class Api::V1::UsersController < ApplicationController
    before_action :authorize_request, except: :create
    before_action :find_user, except: %i[create index password]

    def index
        @users = User.all
        render json: { data: ActiveModelSerializers::SerializableResource.new(@users), status: true }, status: :ok
    end

    def show
        render json: { data: {user: ActiveModelSerializers::SerializableResource.new(@user)}, status: true}, status: :ok
    end

    def create
        @user = User.new(user_params)
        if @user.save
            @user.active_account
            render json: { data: {user: ActiveModelSerializers::SerializableResource.new(@user)}, status: true}, status: :created
        else
            render json: { errors: @user.errors.full_messages, message: @user.errors.full_messages, status: false },
                    status: :ok
        end
    end

    def update
        unless @user.update(user_params)
            render json: { errors: @user.errors.full_messages, message: @user.errors.full_messages, status: false },
                    status: :ok
            return
        end
        render json: { data: {user: ActiveModelSerializers::SerializableResource.new(@user)}, message: 'Successfully updated!', status: true}, status: :ok
    end

    def destroy
        @user.destroy
        render json: { data: {}, message: 'Successfully deleted!', status: true}, status: :ok
    end

    def password
        user = User.find_by_id!(params[:id])
        unless user.present?
            render json: { errors: 'User not found', message: 'User not found', status: false}, status: :ok
        end
        unless user.reset_password!(params[:password])
            render json: { errors: user.errors.full_messages, message: user.errors.full_messages, status: false}, status: :ok
        end
        teams = user.teams_as_member
        user.teams_as_member.each do |team|
            blocks = [
                SLACK_HEADER_ENROLL,
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": "#{user.name} has successfully enrolled in Welcome HR"
                    }
                }
            ]
            team.user.send_message_to_slack(blocks)
        end
        render json: { data: {user: user}, message: 'Successfully password updated!', status: true}, status: :ok
    end

    private

    def find_user
        @user = User.find_by_id!(params[:user_id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'User not found', status: false }, status: :not_found
    end

    def user_params
        params.permit(
        :photo_url, :username, :email, :password, :password_confirmation, 
        :user_type, :status, :first_name, :last_name, :middle_name, 
        :phone_number, :address, :city, :state, :country, 
        :postal_code, :is_first_login, :emergency_first_name, :emergency_last_name,
        :emergency_email, :emergency_phone_number, :emergency_relationship
        )
    end
end
