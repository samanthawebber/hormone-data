class User < ApplicationRecord
  has_secure_password
  has_secure_token :api_token

  has_many :studies, dependent: :destroy
  has_many :submissions, dependent: :destroy

  before_validation :normalize_email

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  def anonymous_handle
    "participant-#{id.to_s.rjust(4, '0')}"
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
