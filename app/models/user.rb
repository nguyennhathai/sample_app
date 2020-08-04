class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.user.email_regex
  USERS_PARAMS = %i(name email password password_confirmation).freeze

  validates :name, presence: true,
    length: {maximum: Settings.user.username_maximum}

  validates :email, presence: true,
    length: {maximum: Settings.user.email_maximum},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true

  validates :password, presence: true,
    length: {minimum: Settings.user.password_minimum}

  before_save :email_downcase

  has_secure_password

  private

  def email_downcase
    self.email = email.downcase
  end
end
