class Api::V1::TeamMembersController < ApplicationController
    before_action :authorize_request
    before_action :find_team_member, except: %i[create index own_team_members]

    def index
        @team_members = TeamMember.filter_collection(filter_params).ordered
        @team_members = ActiveModelSerializers::SerializableResource.new(@team_members, each_serializer: TeamMemberSerializer)
        render json: { data: @team_members, status: true }, status: :ok
    end

    def show
        @team_member = ActiveModelSerializers::SerializableResource.new(@team_member, each_serializer: TeamMemberSerializer)
        render json: { data: @team_member, status: true}, status: :ok
    end

    def create
        @team_member = TeamMember.new(team_member_params)
        if @team_member.save
            @team_member.post_general_channel(@current_user)
            if params[:reporter]
                @reporter = User.find_by_id!(params[:reporter])
                report_member
            end
            render json: { data: {team_member: @team_member}, status: true}, status: :created
        else
            render json: { errors: @team_member.errors.full_messages, message: @team_member.errors.full_messages, status: false },
                    status: :ok
        end
    end

    def update
        unless @team_member.update(team_member_params)
            render json: { errors: @team_member.errors.full_messages, message: @team_member.errors.full_messages, status: false },
                    status: :ok
        end
        render json: { data: {team_member: @team_member}, message: 'Successfully updated!', status: true}, status: :ok
    end

    def destroy
        @team_member.destroy
        render json: { data: {}, message: 'Successfully deleted!', status: true}, status: :ok
    end

    def own_team_members
        @team_members = @current_user.my_all_team_members
        @team_members = @team_members.count > 0 ? ActiveModelSerializers::SerializableResource.new(@team_members) : { team_members: [] }
        render json: { data: @team_members, status: true }, status: :ok
    end

    def histories
        team_members = TeamMember.where(email_address: @team_member.email_address)
        team_members = ActiveModelSerializers::SerializableResource.new(team_members, each_serializer: TeamMemberSerializer)
        render json: { data: team_members, status: true}, status: :ok
    end

    private

    def find_team_member
        @team_member = TeamMember.find_by_id!(params[:team_member_id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Team Member not found', message: 'Team Member not found', status: false }, status: :ok
    end

    def team_member_params
        params.permit(
        :team_id, 
        :title_id,
        :job_title_id,
        :first_name, 
        :last_name, 
        :base_comp, 
        :email_address, 
        :share_stock, 
        :onboarding_email, 
        :start_date, 
        :review_schedule, 
        :status
        ).delocalize(start_date: :date)
    end

    def filter_params
        params.slice(
            :team_id, 
            :title_id, 
            :job_title_id,
            :first_name, 
            :last_name, 
            :email_address, 
            :start_date, 
            :end_date, 
            :status
        ).delocalize(start_date: :date, end_date: :date)
    end

    def report_member
        if @reporter.present?
            TeamMemberMailer.report_team_member(@reporter, @team_member).deliver_now
        end
    end
end
