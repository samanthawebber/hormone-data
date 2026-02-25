class StudiesController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :set_study, only: :show

  def index
    studies = Study.includes(:study_parameters, :submissions).order(created_at: :desc)
    render json: { studies: studies.map { |study| study_summary(study) } }
  end

  def show
    ordered_submissions = @study.submissions.includes(:user).order(created_at: :asc)
    recent_submissions = ordered_submissions.last(20).reverse

    chart_data = @study.study_parameters.map do |parameter|
      points = ordered_submissions.filter_map do |submission|
        raw_value = submission.values&.[](parameter.name)
        next if raw_value.blank?

        { x: submission.created_at.iso8601, y: raw_value.to_f }
      end

      values = points.map { |point| point[:y] }
      {
        parameter_id: parameter.id,
        name: parameter.name,
        unit: parameter.unit,
        average: values.empty? ? nil : (values.sum / values.length.to_f).round(2),
        points: points
      }
    end

    render json: {
      study: study_detail(@study),
      chart_data: chart_data,
      recent_submissions: recent_submissions.map { |submission| submission_payload(submission) }
    }
  end

  def create
    study = current_user.studies.new(study_params)

    if study.save
      render json: { study: study_detail(study) }, status: :created
    else
      render json: { errors: study.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_study
    @study = Study.includes(:study_parameters, submissions: :user).find_by!(slug: params[:id])
  end

  def study_params
    params.require(:study).permit(
      :title,
      :description,
      :topic,
      study_parameters_attributes: %i[id name unit min_value max_value position]
    )
  end

  def study_summary(study)
    {
      id: study.id,
      slug: study.slug,
      title: study.title,
      topic: study.topic,
      description: study.description,
      creator_alias: study.user.anonymous_handle,
      parameters: study.study_parameters.map { |parameter| parameter_payload(parameter) },
      submission_count: study.submissions.size,
      created_at: study.created_at
    }
  end

  def study_detail(study)
    {
      id: study.id,
      slug: study.slug,
      title: study.title,
      topic: study.topic,
      description: study.description,
      creator_alias: study.user.anonymous_handle,
      parameters: study.study_parameters.map { |parameter| parameter_payload(parameter) },
      submission_count: study.submissions.size,
      created_at: study.created_at
    }
  end

  def parameter_payload(parameter)
    {
      id: parameter.id,
      name: parameter.name,
      unit: parameter.unit,
      min_value: parameter.min_value,
      max_value: parameter.max_value,
      position: parameter.position
    }
  end

  def submission_payload(submission)
    {
      id: submission.id,
      submitted_at: submission.created_at,
      participant_alias: submission.user.anonymous_handle,
      values: submission.values
    }
  end
end
