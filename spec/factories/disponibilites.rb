FactoryBot.define do
  factory :horaire_disponibilite do
    association :artisan
    jour { HoraireDisponibilite.jours.keys.sample }
    heure_debut { "09:00" }
    heure_fin { "17:00" }
    est_actif { true }

    trait :inactive do
      est_actif { false }
    end

    trait :matin do
      heure_debut { "08:00" }
      heure_fin { "12:00" }
    end

    trait :apres_midi do
      heure_debut { "14:00" }
      heure_fin { "18:00" }
    end
  end

  factory :disponibilite_exceptionnelle do
    association :artisan
    date_debut { Time.current + 1.day }
    date_fin { Time.current + 2.days }
    raison { Faker::Lorem.sentence }
    est_disponible { false }

    trait :disponible do
      est_disponible { true }
    end

    trait :passee do
      date_debut { Time.current - 2.days }
      date_fin { Time.current - 1.day }
    end

    trait :future do
      date_debut { Time.current + 1.week }
      date_fin { Time.current + 8.days }
    end
  end
end
