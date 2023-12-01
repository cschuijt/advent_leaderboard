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

      expect(day.start_time.year).to eq(2023)
      expect(day.start_time.month).to eq(12)
      expect(day.start_time.day).to eq(1)
      expect(day.start_time.hour).to eq(5)
      expect(day.start_time.minute).to eq(0)
    end
  end

  describe 'end_time' do
    it 'should be at 5AM UTC on the next day' do
      year = create(:year, number: 2023)
      day = create(:day, year: year, number: 1)

      expect(day.end_time.year).to eq(2023)
      expect(day.end_time.month).to eq(12)
      expect(day.end_time.day).to eq(2)
      expect(day.end_time.hour).to eq(5)
      expect(day.end_time.minute).to eq(0)
    end
  end
end
