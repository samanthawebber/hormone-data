class Study < ApplicationRecord
  belongs_to :user
  has_many :study_parameters, -> { order(:position, :id) }, dependent: :destroy
  has_many :submissions, dependent: :destroy

  before_validation :assign_slug

  accepts_nested_attributes_for :study_parameters,
                                allow_destroy: true,
                                reject_if: proc { |attrs| attrs["name"].blank? }

  validates :title, presence: true
  validates :description, presence: true
  validates :slug, presence: true, uniqueness: true

  def to_param
    slug
  end

  private

  def assign_slug
    return if title.blank?
    return unless slug.blank? || will_save_change_to_title?

    base = title.to_s.parameterize.presence || "study"
    candidate = base
    counter = 2

    while self.class.where(slug: candidate).where.not(id: id).exists?
      candidate = "#{base}-#{counter}"
      counter += 1
    end

    self.slug = candidate
  end
end
