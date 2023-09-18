class Api::V1::TeamsController < ApplicationController
    before_action :authorize_request
    before_action :find_team, except: %i[create index own_teams]

    def index
        @teams = Team.all
        render json: { data: {teams: @teams}, status: true }, status: :ok
    end

    def show
        render json: { data: {team: @team}, status: true}, status: :ok
    end

    def create
        @team = Team.new(team_params)
        unless team_params.has_key?(:user_id)
          @team.user = @current_user
        end
        unless team_params.has_key?(:company_id)
            @team.company = @current_user.companies.first
          end
        if @team.save
            render json: { data: {team: @team}, status: true}, status: :created
        else
            render json: { errors: @team.errors.full_messages, message: @team.errors.full_messages, status: false },
                    status: :ok
        end
    end

    def update
        unless @team.update(team_params)
            render json: { errors: @team.errors.full_messages, message: @team.errors.full_messages, status: false },
                    status: :ok
        end
        render json: { data: {team: @team}, message: 'Successfully updated!', status: true}, status: :ok
    end

    def destroy
        @team.destroy
        render json: { data: {}, message: 'Successfully deleted!', status: true}, status: :ok
    end

    def own_teams
      @teams = @current_user.my_all_teams
      @teams = @teams.count > 0 ? ActiveModelSerializers::SerializableResource.new(@teams) : { teams: []}
      render json: { data: @teams, status: true }, status: :ok
    end

    private

    def find_team
        @team = Team.find_by_id!(params[:team_id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Team not found', message: 'Team not found', status: false }, status: :ok
    end

    def team_params
        params.permit(
        :name, :description, :status, :user_id, :company_id
        )
    end
end
