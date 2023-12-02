require 'rails_helper'

RSpec.describe DaysHelper, type: :helper do
  describe 'counts' do
    before :each do
      @day = create(:day)

      # Incompletes
      5.times do
        create(:participant, year: @day.year)
      end

      # Silvers
      3.times do
        participant = create(:participant, year: @day.year)
        create(:star, index: 1, participant: participant, day: @day)
      end

      # Golds
      2.times do
        participant = create(:participant, year: @day.year)
        create(:star, index: 1, participant: participant, day: @day)
        create(:star, index: 2, participant: participant, day: @day)
      end
    end

    describe 'count_incomplete' do
      it 'should count all participants that have not completed the day' do
        expect(count_incomplete(@day)).to eq(5)
      end

      it 'should add one when an incomplete participant is added' do
        expect { create(:participant, year: @day.year) }
              .to change { count_incomplete(@day) }.by(1)
      end

      it 'should not change when a silver user is added' do
        expect {
          participant = create(:participant, year: @day.year)
          create(:star, day: @day, index: 1, participant: participant)
        }.not_to change { count_incomplete(@day) }
      end

      it 'should not change when a gold user is added' do
        expect {
          participant = create(:participant, year: @day.year)
          create(:star, index: 1, participant: participant, day: @day)
          create(:star, index: 2, participant: participant, day: @day)
        }.not_to change { count_incomplete(@day) }
      end
    end

    describe 'count_silver' do
      it 'should count all participants with at least one star' do
        expect(count_silver(@day)).to eq(3)
      end

      it 'should add one when a new user with one star is added' do
        expect { create(:star, day: @day, index: 1) }
              .to change { count_silver(@day) }.by(1)
      end

      it 'should not change when an incomplete user is added' do
        expect { create(:participant, year: @day.year) }
              .not_to change { count_silver(@day) }
      end

      it 'should not change when a gold user is added' do
        expect {
          participant = create(:participant, year: @day.year)
          create(:star, index: 1, participant: participant, day: @day)
          create(:star, index: 2, participant: participant, day: @day)
        }.not_to change { count_silver(@day) }
      end
    end

    describe 'count_gold' do
      it 'should count all participants with two stars' do
        expect(count_gold(@day)).to eq(2)
      end

      it 'should add one when a user with two stars is added' do
        expect {
          participant = create(:participant, year: @day.year)
          create(:star, index: 1, participant: participant, day: @day)
          create(:star, index: 2, participant: participant, day: @day)
        }.to change { count_gold(@day) }.by(1)
      end

      it 'should not change when a silver user is added' do
        expect { create(:star, day: @day, index: 1) }
              .not_to change { count_gold(@day) }
      end

      it 'should not change when an incomplete user is added' do
        expect { create(:participant, year: @day.year) }
              .not_to change { count_gold(@day) }
      end
    end

    describe 'count_silver_stars' do
      it 'should count all silver stars' do
        expect(count_silver_stars(@day)).to eq(5)
      end

      it 'should increase when a silver user is added' do
        expect {
          participant = create(:participant, year: @day.year)
          create(:star, day: @day, index: 1, participant: participant)
        }.to change { count_silver_stars(@day) }.by(1)
      end

      it 'should increase when a gold user is added' do
        expect {
          participant = create(:participant, year: @day.year)
          create(:star, index: 1, participant: participant, day: @day)
          create(:star, index: 2, participant: participant, day: @day)
        }.to change { count_silver_stars(@day) }.by(1)
      end

      it 'should not change when an incomplete user is added' do
        expect { create(:participant, year: @day.year) }
              .not_to change { count_silver_stars(@day) }
      end
    end
  end

  describe 'top_speeds' do
    before :each do
      @day = create(:day)

      time = Time.utc(2023, 12, 1, 10)
      10.times do
        create(:star, completed_at: time, index: 1, day: @day)
        time = time + 1.hour
      end

      10.times do
        create(:star, completed_at: time, index: 2, day: @day)
        time = time + 1.hour
      end
    end

    it 'should only return stars for the given day' do
      wrong_star = create(:star, day: create(:day, year: @day.year, number: 2), index: 2)

      expect(top_speeds(@day, 2, 20)).not_to include(wrong_star)
    end

    it 'should return 3 stars by default' do
      expect(top_speeds(@day, 2).length).to eq(3)
    end

    it 'should return gold stars by default' do
      expect(top_speeds(@day).all? { |s| s.index == 2 }).to eq(true)
    end

    it 'should return the fastest stars' do
      expect(
        top_speeds(@day, 1, 5).last.completed_at < Time.utc(2023, 12, 1, 17)
      ).to eq(true)
    end
  end

  describe 'time_taken' do
    before :each do
      @year = create(:year, number: 2023)
      @day  = create(:day, number: 1, year: @year)
    end

    it 'should return formatted time from 5AM UTC' do
      star = create(
        :star,
        day:          @day,
        completed_at: Time.utc(2023, 12, 1, 7, 49, 24)
      )
      expect(time_taken(@day, star)).to eq('2h, 49m, 24s')
    end

    it 'should return a fixed string when the difference is over 24 hours' do
      star = create(
        :star,
        day:          @day,
        completed_at: Time.utc(2023, 12, 4)
      )
      expect(time_taken(@day, star)).to eq('>24 hrs')
    end
  end
end
