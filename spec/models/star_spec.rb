require 'rails_helper'

RSpec.describe Star, type: :model do
  it 'should be valid with default attributes' do
    star = build(:star)
    expect(star).to be_valid
  end

  it 'should respond to year' do
    star = create(:star)
    expect(star).to respond_to(:year)
  end

  it 'should respond to user' do
    star = create(:star)
    expect(star).to respond_to(:user)
  end

  describe 'index' do
    it 'should not be nil' do
      star = build(:star, index: nil)
      expect(star).to be_invalid
    end

    it 'should be unique in the same day for the same participant' do
      star_1 = create(:star)
      star_2 = build(:star, participant: star_1.participant, day: star_1.day)

      expect(star_2).to be_invalid
    end

    it 'should not have to be unique for different participants' do
      star_1 = create(:star)
      star_2 = build(:star, day: star_1.day)

      expect(star_2).to be_valid
    end

    it 'should not have to be unique for different days' do
      star_1 = create(:star)
      star_2 = build(:star, participant: star_1.participant)
    end
  end
end
