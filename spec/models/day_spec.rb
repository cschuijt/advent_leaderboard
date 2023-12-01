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

  describe 'start_time' do
    it 'should be at 5AM UTC on the given day' do
      year = create(:year, number: 2023)
      day = create(:day, year: year, number: 1)

      expect(day.start_time).to eq(Time.utc(2023, 12, 1, 5))
    end
  end

  describe 'end_time' do
    it 'should be at 5AM UTC on the next day' do
      year = create(:year, number: 2023)
      day = create(:day, year: year, number: 1)

      expect(day.end_time).to eq(Time.utc(2023, 12, 2, 5))
    end
  end
end
