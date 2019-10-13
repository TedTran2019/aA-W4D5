# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  password_digest :string           not null
#  session_token   :string           not null
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_session_token  (session_token) UNIQUE
#  index_users_on_username       (username) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user, username: 'Ted', password: '123456') }

  describe 'attributes' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_presence_of(:session_token) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:session_token) }

    it 'creates a session token before validation' do
      user.valid?
      expect(user.session_token).to_not eq(nil)
    end

    it 'creates a password digest when a password is given' do
      expect(user.password_digest).to_not eq(nil)
    end
  end

  describe 'methods' do
    describe 'class methods' do
      describe '::find_by_credentials' do
        before(:each) { user.save! }
        context 'correct credentials' do
          it 'should return the user given correct credentials' do
            expect(User.find_by_credentials('Ted', '123456')).to eq(user)
          end
        end

        context 'incorrect credentials' do
          it 'should return nil given incorrect credentials' do
            expect(User.find_by_credentials('Ted', 'nope')).to eq(nil)
          end
        end
      end
    end

    describe 'instance methods' do
      describe '#reset_session_token!' do
        it "should reset the user's session token" do
          old_token = user.session_token
          user.reset_session_token!
          # Small chance to fail due to randomly generated session tokens
          expect(old_token).to_not eq(user.session_token)
        end

        it 'should return the new session token' do
          expect(user.reset_session_token!).to eq(user.session_token)
        end
      end

      describe '#is_password?' do
        it 'should return true when it is the password' do
          expect(user.is_password?('123456')).to eq(true)
        end

        it "should return false when it isn't the password" do
          expect(user.is_password?('nope')).to eq(false)
        end
      end
    end
  end

  describe 'associations' do

  end
end
