class User < ApplicationRecord
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }

  def self.authenticate_with_credentials(email, password)
    user = find_by(email: email.strip.downcase)

    if user && user.authenticate(password)
      user
    else
      nil
    end
  end
end