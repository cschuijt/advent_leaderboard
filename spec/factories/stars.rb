FactoryBot.define do
  factory :star do
    day
    participant
    index        { 1 }
    completed_at { Time.now }
  end
end
