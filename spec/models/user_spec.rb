# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_db_column(:email).of_type(:string).with_options(null: false, default: '') }
  it { should have_db_column(:encrypted_password).of_type(:string).with_options(null: false, default: '') }
  it { should have_db_column(:role).of_type(:integer).with_options(null: false, default: :member) }

  describe 'role enum' do
    it { should define_enum_for(:role).with_values(member: 0, librarian: 1) }

    it 'defaults to user role' do
      user = User.new
      expect(user.role).to eq('member')
      expect(user.member?).to be_truthy
    end

    it 'can be set to librarian' do
      user = User.new(role: :librarian)
      expect(user.role).to eq('librarian')
      expect(user.librarian?).to be_truthy
    end
  end
end
