FactoryBot.define do
  factory :metier do
    nom { Faker::Job.field }
    description { Faker::Lorem.paragraph }

    trait :with_services do
      after(:create) do |metier|
        create_list(:service, 3, metier: metier)
      end
    end
  end

  factory :service do
    association :metier
    nom { Faker::Job.position }
    description { Faker::Lorem.paragraph }
    prix_base { Faker::Number.decimal(l_digits: 2) }
  end
end
