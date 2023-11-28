FactoryBot.define do
  factory :user do
    sequence(:username)    { |n| "user#{n}" }
    full_name              { 'User Name' }
    photo_url              { 'https://cdn.intra.42.fr/users/deadbeef/photo.png' }
    sequence(:aoc_user_id) { |n| (2000000 + n).to_s }
  end
end
