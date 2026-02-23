FactoryBot.define do
  factory :note do
    association :user
    title { Faker::Movies::StarWars.quote }
    content { Faker::Lorem.paragraph(sentence_count: 2) }
    note_type { :review }

    trait :critique do
      note_type { :critique }
      content { Faker::Lorem.paragraph(sentence_count: 4) }
    end
  end
end
