require 'rails_helper'

RSpec.describe Participant, type: :model do
  it 'should be valid with default attributes' do
    participant = build(:participant)
    expect(participant).to be_valid
  end

  it 'should respond to User methods' do
    participant = create(:participant)
    expect(participant).to respond_to(
      :username, :full_name, :photo_url, :aoc_user_id
    )
  end

  it 'should respond to intra_url' do
    user = create(:user)
    expect(user).to respond_to(:intra_url)
  end

  describe 'user' do
    it 'should not have to be unique across different years' do
      user          = create(:user)
      participant   = create(:participant, user: user)
      participant_2 = build(:participant, user: user)

      expect(participant_2).to be_valid
    end

    it 'should be unique within the same year' do
      user          = create(:user)
      participant   = create(:participant, user: user)
      participant_2 = build(:participant, user: user, year: participant.year)

      expect(participant_2).to be_invalid
    end
  end

  describe 'stars' do
    it 'should be destroyed when the participant is destroyed' do
      star = create(:star)

      expect { star.participant.destroy }.to change { Star.count }.by(-1)
    end
  end

  describe 'gold_stars' do
    it 'should contain all gold stars' do
      participant = create(:participant)

      gold_star_1 = create(:star, participant: participant, index: 2)
      gold_star_2 = create(:star, participant: participant, index: 2)
      silver_star = create(:star, participant: participant, index: 1)

      expect(participant.reload.gold_stars).to include(gold_star_1, gold_star_2)
    end

    it 'should not contain silver stars' do
      participant = create(:participant)

      gold_star_1 = create(:star, participant: participant, index: 2)
      gold_star_2 = create(:star, participant: participant, index: 2)
      silver_star = create(:star, participant: participant, index: 1)

      expect(participant.reload.gold_stars).not_to include(silver_star)
    end
  end

  describe 'silver_stars' do
    it 'should contain all silver stars' do
      participant = create(:participant)

      gold_star_1 = create(:star, participant: participant, index: 2)
      gold_star_2 = create(:star, participant: participant, index: 2)
      silver_star = create(:star, participant: participant, index: 1)

      expect(participant.reload.silver_stars).to include(silver_star)
    end

    it 'should not contain gold stars' do
      participant = create(:participant)

      gold_star_1 = create(:star, participant: participant, index: 2)
      gold_star_2 = create(:star, participant: participant, index: 2)
      silver_star = create(:star, participant: participant, index: 1)

      expect(participant.reload.silver_stars).not_to include(gold_star_1, gold_star_2)
    end
  end
end
