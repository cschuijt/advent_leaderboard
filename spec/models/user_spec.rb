require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should be valid with the default attributes' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'should respond to years' do
    user = create(:user)
    expect(user).to respond_to(:years)
  end

  it 'should respond to stars' do
    user = create(:user)
    expect(user).to respond_to(:stars)
  end

  it 'should respond to participations' do
    user = create(:user)
    expect(user).to respond_to(:participations)
  end

  it 'should respond to the 42 API as a class method' do
    expect(User).to respond_to(:fortytwo_api_client)
  end

  describe 'aoc_user_id' do
    it 'can be nil' do
      user = build(:user, aoc_user_id: nil)
      expect(user).to be_valid
    end

    it 'can accept numeric values' do
      user = build(:user, aoc_user_id: '1324567890')
      expect(user).to be_valid
    end

    it 'strips # from the input' do
      user = build(:user, aoc_user_id: '#1234')
      user.save!
      expect(user.reload.aoc_user_id).to eq('1234')
    end

    it 'does not accept non-numeric characters' do
      user = build(:user, aoc_user_id: '1234f56')
      expect(user).to be_invalid
    end

    it 'should be unique' do
      user_1 = create(:user)
      user_2 = build(:user, aoc_user_id: user_1.aoc_user_id)

      expect(user_2).to be_invalid
    end
  end

  describe 'username' do
    it 'should not be nil' do
      user = build(:user, username: nil)
      expect(user).to be_invalid
    end

    it 'should not be empty' do
      user = build(:user, username: '')
      expect(user).to be_invalid
    end

    it 'should be unique' do
      user_1 = create(:user)
      user_2 = build(:user, username: user_1.username)

      expect(user_2).to be_invalid
    end
  end

  describe 'participations' do
    it 'should be destroyed when the user is destroyed' do
      participant = create(:participant)
      expect { participant.user.destroy }.to change { Participant.count }.by(-1)
    end
  end

  describe 'intra_url' do
    it 'should return a proper intra URL' do
      user = create(:user)

      expect(user.intra_url).to eq("https://profile.intra.42.fr/users/#{user.username}")
    end
  end
end
