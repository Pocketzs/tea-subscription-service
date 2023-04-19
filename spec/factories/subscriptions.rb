FactoryBot.define do
  factory :subscription do
    title { Faker::Emotion.noun.capitalize }
    price { Faker::Number.within(range: 1000..10000) }
    status { 0 }
    frequency { Faker::Number.within(range: 1..5) }
  end
end
