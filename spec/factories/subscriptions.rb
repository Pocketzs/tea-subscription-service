FactoryBot.define do
  factory :subscription do
    title { Faker::Emotion.noun.capitalize }
    price { Faker::Number.within(range: 1000..10000) }
    frequency { Faker::Number.within(range: 0..1) }
  end
end
