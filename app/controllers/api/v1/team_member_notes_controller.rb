class Api::V1::TeamMemberNotesController < ApplicationController
    before_action :authorize_request
    before_action :find_team_member_note, except: %i[create index]

    def index
        @team_member_note = TeamMemberNote.filter_collection(filter_params).ordered
        @team_member_note = ActiveModelSerializers::SerializableResource.new(@team_member_note, each_serializer: TeamMemberSerializer)
        render json: { data: @team_member_note, status: true }, status: :ok
    end

    def show
        render json: { data: {team_member_note: @team_member_note}, status: true}, status: :ok
    end

    def create
        @team_member_note = TeamMemberNote.new(team_member_note_params)
        if @team_member_note.save
            render json: { data: {team_member_note: @team_member_note}, status: true}, status: :created
        else
            render json: { errors: @team_member_note.errors.full_messages, message: @team_member_note.errors.full_messages, status: false },
                    status: :ok
        end
    end

    def update
        unless @team_member_note.update(team_member_note_params)
            render json: { errors: @team_member_note.errors.full_messages, message: @team_member_note.errors.full_messages, status: false },
                    status: :ok
        end
        render json: { data: {team_member_note: @team_member_note}, message: 'Successfully updated!', status: true}, status: :ok
    end

    def destroy
        @team_member_note.destroy
        render json: { data: {}, message: 'Successfully deleted!', status: true}, status: :ok
    end

    private

    def find_team_member_note
        @team_member_note = TeamMemberNote.find_by_id!(params[:team_member_note_id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Team Member Note not found', message: 'Team Member Note not found', status: false }, status: :ok
    end

    def team_member_note_params
        params.permit(
        :team_member_id, 
        :note_type, 
        :description, 
        :scoring_matrix, 
        :praise, 
        :improvements, 
        :plan_name, 
        :core_kpis, 
        :start_date, 
        :end_date, 
        :reason_for_change, 
        :base_comp, 
        :stop_comp, 
        :effective_date, 
        :manager_id, 
        :team_id, 
        :title_id,
        :status
        ).delocalize(start_date: :date, end_date: :date, effective_date: :date)
    end

    def filter_params
        params.slice(
            :team_member_id, 
            :note_type, 
            :description, 
            :scoring_matrix, 
            :praise, 
            :improvements, 
            :plan_name, 
            :core_kpis, 
            :start_date, 
            :end_date, 
            :reason_for_change, 
            :base_comp, 
            :stop_comp, 
            :effective_date, 
            :manager_id, 
            :team_id, 
            :title_id, 
            :status
        ).delocalize(start_date: :date, end_date: :date, effective_date: :date)
      end
end
