FactoryBot.define do
  factory :year do
    sequence(:number) { |n| (2000 + n).to_s }
  end
end
