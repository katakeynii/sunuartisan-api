FactoryBot.define do
  factory :requete_service do
    association :client
    description { Faker::Lorem.paragraph }
    budget_estime { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    date_souhaitee { Time.current + 2.days }
    status { 'EN_ATTENTE' }
    est_ouvert { true }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }

    trait :fermee do
      est_ouvert { false }
    end

    trait :acceptee do
      status { 'ACCEPTE' }
    end

    trait :en_cours do
      status { 'EN_COURS' }
    end

    trait :terminee do
      status { 'TERMINE' }
    end

    trait :annulee do
      status { 'ANNULE' }
    end

    trait :with_services do
      after(:create) do |requete|
        requete.services << create_list(:service, 2)
      end
    end
  end

  factory :offre do
    association :artisan
    association :requete_service
    prix_propose { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    description { Faker::Lorem.paragraph }
    necessite_deplacement { false }
    refusee { false }

    trait :avec_deplacement do
      necessite_deplacement { true }
    end

    trait :refusee do
      refusee { true }
    end

    trait :pour_requete_acceptee do
      association :requete_service, factory: [ :requete_service, :acceptee ]
    end
  end
end
