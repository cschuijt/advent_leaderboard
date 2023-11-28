require 'rails_helper'

RSpec.describe Year, type: :model do
  it 'should be valid with the default attributes' do
    year = build(:year)
    expect(year).to be_valid
  end

  it 'should respond to stars' do
    year = create(:year)
    expect(year).to respond_to(:stars)
  end

  it 'should respond to users' do
    year = create(:year)
    expect(year).to respond_to(:users)
  end

  describe 'number' do
    it 'should not be nil' do
      year = build(:year, number: nil)
      expect(year).to be_invalid
    end

    it 'should be unique' do
      year_1 = create(:year)
      year_2 = build(:year, number: year_1.number)
      expect(year_2).to be_invalid
    end
  end

  describe 'days' do
    it 'should be destroyed when the year is destroyed' do
      day = create(:day)
      expect { day.year.destroy }.to change { Day.count }.by(-1)
    end
  end

  describe 'participants' do
    it 'should be destroyed when the year is destroyed' do
      participant = create(:participant)
      expect { participant.year.destroy }.to change { Participant.count }.by(-1)
    end
  end
end
