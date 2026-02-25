class Submission < ApplicationRecord
  belongs_to :study
  belongs_to :user

  serialize :values, coder: JSON

  validates :values, presence: true
  validate :contains_all_study_parameters

  private

  def contains_all_study_parameters
    missing = study.study_parameters.filter_map do |parameter|
      key = parameter.name
      value = values&.[](key)
      key if value.blank?
    end

    return if missing.empty?

    errors.add(:values, "is missing: #{missing.join(', ')}")
  end
end
