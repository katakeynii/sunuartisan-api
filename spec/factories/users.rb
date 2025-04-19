FactoryBot.define do
  factory :user do
    telephone { Faker::PhoneNumber.cell_phone_in_e164 }
    nom { Faker::Name.last_name }
    prenom { Faker::Name.first_name }
    adresse { Faker::Address.full_address }
    password { 'password123' }
    status { 'EN_ATTENTE' }
  end

  factory :client do
    telephone { Faker::PhoneNumber.cell_phone_in_e164 }
    nom { Faker::Name.last_name }
    prenom { Faker::Name.first_name }
    adresse { Faker::Address.full_address }
    email { Faker::Internet.email }
    password { 'password123' }
    status { 'VERIFIE' }
  end

  factory :artisan do
    telephone { Faker::PhoneNumber.cell_phone_in_e164 }
    nom { Faker::Name.last_name }
    prenom { Faker::Name.first_name }
    adresse { Faker::Address.full_address }
    password { 'password123' }
    status { 'EN_ATTENTE' }
    cni_numero { Faker::IDNumber.valid }
    verified { false }
    est_disponible { true }
    note_moyenne { 0.0 }

    trait :verified do
      verified { true }
      status { 'VERIFIE' }
    end

    trait :with_photos do
      after(:build) do |artisan|
        artisan.cni_photo.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'cni.jpg')),
          filename: 'cni.jpg',
          content_type: 'image/jpeg'
        )
        artisan.profile_photo.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'profile.jpg')),
          filename: 'profile.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
