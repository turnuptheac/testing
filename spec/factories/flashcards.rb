FactoryGirl.define do
  factory :flashcard do
    question { Faker::Hipster.word }
    answer { Faker::Hipster.sentence }
  end
end
