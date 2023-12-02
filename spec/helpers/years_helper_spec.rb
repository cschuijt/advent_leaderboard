require 'rails_helper'

RSpec.describe YearsHelper, type: :helper do
  describe 'count_completed_days' do
    before :each do
      @year = create(:year, number: 2023)

      i = 1
      5.times do
        create(:day, year: @year, number: i)
        i = i + 1
      end

      6.times do
        day = create(:day, year: @year, number: i)
        participant = create(:participant, year: @year)
        create(:star, day: day, index: 1, participant: participant)
        i = i + 1
      end

      4.times do
        day = create(:day, year: @year, number: i)
        participant = create(:participant, year: @year)
        create(:star, day: day, index: 1, participant: participant)
        create(:star, day: day, index: 2, participant: participant)
        i = i + 1
      end
    end

    it 'should count all days with a star' do
      expect(count_completed_days(@year)).to eq(10)
    end

    it 'should change when a new star is obtained' do
      expect {
        participant = create(:participant, year: @year)
        create(:star, day: @year.days.find_by(number: 1), index: 1, participant: participant)
      }.to change { count_completed_days(@year) }.by(1)
    end

    it 'should not count the same day twice' do
      expect {
        participant = create(:participant, year: @year)
        create(:star, day: @year.days.find_by(number: 7), index: 1, participant: participant)
      }.not_to change { count_completed_days(@year) }
    end
  end
end
