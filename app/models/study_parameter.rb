class StudyParameter < ApplicationRecord
  belongs_to :study

  validates :name, presence: true
  validates :min_value, numericality: true, allow_nil: true
  validates :max_value, numericality: true, allow_nil: true
  validate :min_less_than_max

  private

  def min_less_than_max
    return if min_value.nil? || max_value.nil?
    return if min_value <= max_value

    errors.add(:max_value, "must be greater than or equal to minimum")
  end
end
