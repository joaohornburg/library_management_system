require 'rails_helper'

RSpec.describe UserSerializer do
  describe '.render' do
    let(:user) { User.create!(email: 'test@example.com', password: 'password', role: :member) }

    it 'returns the correct user representation' do
      serialized_user = described_class.render(user)
      
      expect(serialized_user).to include(
        id: user.id,
        email: user.email,
        role: user.role
      )
    end
  end
end 