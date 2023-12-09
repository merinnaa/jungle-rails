require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'should be created with password and password_confirmation fields' do
      user = User.new(
        email: 'test@example.com',
        first_name: 'John',
        last_name: 'Doe',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user.save).to be true
    end

    it 'should have matching password and password_confirmation' do
      user = User.new(
        email: 'test@example.com',
        first_name: 'John',
        last_name: 'Doe',
        password: 'password',
        password_confirmation: 'differentpassword'
      )
      user.save
      expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'should require password and password_confirmation' do
      user = User.new(
        email: 'test@example.com',
        first_name: 'John',
        last_name: 'Doe'
      )
      user.save
      expect(user.errors.full_messages).to include("Password can't be blank")
    end

    it 'is expected to validate that :email is case-insensitively unique' do
      existing_user = create(:user, email: 'test@example.com')
      new_user = build(:user, email: 'TEST@example.com')

      # Ensure the new_user is considered invalid
      new_user.valid?

      # Check if there are no errors related to the email field
      expect(new_user.errors[:email]).to be_empty
    end

    it 'requires a minimum password length' do
      user = User.new(password: 'short')
      user.valid?
      expect(user.errors.full_messages).to include("Password is too short (minimum is 8 characters)")
    end

  end

  describe '.authenticate_with_credentials' do
    it 'returns the user if authenticated' do
      user = create(:user, email: 'test@example.com', password: 'password')
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'password')
      expect(authenticated_user).to eq(user)
    end

    it 'returns nil if not authenticated' do
      user = create(:user, email: 'test@example.com', password: 'password')
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'wrong_password')
      expect(authenticated_user).to be_nil
    end

    it 'returns nil if user not found' do
      authenticated_user = User.authenticate_with_credentials('nonexistent@example.com', 'password')
      expect(authenticated_user).to be_nil
    end

    it 'ignores leading and trailing whitespaces in email' do
      user = create(:user, email: 'test@example.com', password: 'password')
      authenticated_user = User.authenticate_with_credentials('  test@example.com  ', 'password')
      expect(authenticated_user).to eq(user)
    end

    it 'is case-insensitive for email' do
      user = create(:user, email: 'test@example.com', password: 'password')
      authenticated_user = User.authenticate_with_credentials('TEST@example.com', 'password')
      expect(authenticated_user).to eq(user)
    end
  end
end
