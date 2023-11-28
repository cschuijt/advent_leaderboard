require 'rails_helper'

RSpec.describe Day, type: :model do
  it 'should be valid with default attributes' do
    day = build(:day)
    expect(day).to be_valid
  end

  describe 'number' do
    it 'should not have to be unique across different years' do
      day_1 = create(:day)
      day_2 = build(:day)

      expect(day_2).to be_valid
    end

    it 'should be unique within the same year' do
      day_1 = create(:day)
      day_2 = build(:day, year: day_1.year)

      expect(day_2).to be_invalid
    end

    it 'should not be nil' do
      day = build(:day, number: nil)

      expect(day).to be_invalid
    end
  end

  describe 'stars' do
    it 'should be destroyed when the day is destroyed' do
      star = create(:star)

      expect { star.day.destroy }.to change { Star.count }.by(-1)
    end
  end
end
