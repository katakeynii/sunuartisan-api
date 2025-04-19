FactoryBot.define do
  factory :atelier do
    association :artisan
    nom { Faker::Company.name }
    adresse { Faker::Address.full_address }
    description { Faker::Lorem.paragraph }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end

  factory :portfolio do
    association :artisan
    titre { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    image_url { Faker::Internet.url(host: 'example.com', path: '/image.jpg') }

    trait :with_image do
      after(:build) do |portfolio|
        portfolio.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'portfolio.jpg')),
          filename: 'portfolio.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end

  factory :evaluation do
    association :artisan
    association :requete_service, factory: [ :requete_service, :terminee ]
    note { rand(1..5) }
    commentaire { Faker::Lorem.paragraph }

    trait :sans_requete do
      requete_service { nil }
    end
  end

  factory :transaction do
    association :requete_service
    montant { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    reference { "TRX#{Time.current.to_i}#{SecureRandom.hex(3).upcase}" }
    est_complete { false }
    date_paiement { nil }

    trait :completee do
      est_complete { true }
      date_paiement { Time.current }
    end
  end
end
