class SubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_study

  def create
    submission = @study.submissions.new(
      user: current_user,
      values: submission_values
    )

    if submission.save
      render json: {
        submission: {
          id: submission.id,
          study_id: submission.study_id,
          study_slug: submission.study.slug,
          participant_alias: submission.user.anonymous_handle,
          values: submission.values,
          created_at: submission.created_at
        }
      }, status: :created
    else
      render json: { errors: submission.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_study
    @study = Study.includes(:study_parameters).find_by!(slug: params[:study_id])
  end

  def submission_values
    raw_values = params.fetch(:submission, {}).fetch(:values, {})

    @study.study_parameters.each_with_object({}) do |parameter, hash|
      raw_value = raw_values[parameter.id.to_s] || raw_values[parameter.id] || raw_values[parameter.name]
      next if raw_value.blank?

      hash[parameter.name] = raw_value.to_f
    end
  end
end
