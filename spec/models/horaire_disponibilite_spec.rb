require 'rails_helper'

RSpec.describe HoraireDisponibilite, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:jour) }
    it { should validate_presence_of(:heure_debut) }
    it { should validate_presence_of(:heure_fin) }
    it { should belong_to(:artisan) }
  end

  describe 'custom validations' do
    let(:artisan) { create(:artisan) }

    context 'heure_fin_apres_heure_debut' do
      it 'is valid when end time is after start time' do
        horaire = build(:horaire_disponibilite,
                       artisan: artisan,
                       heure_debut: '09:00',
                       heure_fin: '17:00')
        expect(horaire).to be_valid
      end

      it 'is invalid when end time is before start time' do
        horaire = build(:horaire_disponibilite,
                       artisan: artisan,
                       heure_debut: '17:00',
                       heure_fin: '09:00')
        expect(horaire).not_to be_valid
        expect(horaire.errors[:heure_fin]).to include("doit être après l'heure de début")
      end

      it 'is invalid when end time equals start time' do
        horaire = build(:horaire_disponibilite,
                       artisan: artisan,
                       heure_debut: '09:00',
                       heure_fin: '09:00')
        expect(horaire).not_to be_valid
        expect(horaire.errors[:heure_fin]).to include("doit être après l'heure de début")
      end
    end

    context 'pas_de_chevauchement' do
      let!(:existing_horaire) do
        create(:horaire_disponibilite,
               artisan: artisan,
               jour: 'lundi',
               heure_debut: '09:00',
               heure_fin: '17:00')
      end

      it 'is valid when there is no overlap' do
        horaire = build(:horaire_disponibilite,
                       artisan: artisan,
                       jour: 'lundi',
                       heure_debut: '17:00',
                       heure_fin: '20:00')
        expect(horaire).to be_valid
      end

      it 'is invalid when there is overlap' do
        horaire = build(:horaire_disponibilite,
                       artisan: artisan,
                       jour: 'lundi',
                       heure_debut: '12:00',
                       heure_fin: '15:00')
        expect(horaire).not_to be_valid
        expect(horaire.errors[:base]).to include("chevauche un autre horaire de disponibilité")
      end

      it 'allows overlapping times on different days' do
        horaire = build(:horaire_disponibilite,
                       artisan: artisan,
                       jour: 'mardi',
                       heure_debut: '12:00',
                       heure_fin: '15:00')
        expect(horaire).to be_valid
      end
    end
  end

  describe 'scopes' do
    let(:artisan) { create(:artisan) }
    let!(:horaire_actif) { create(:horaire_disponibilite, artisan: artisan, est_actif: true) }
    let!(:horaire_inactif) { create(:horaire_disponibilite, artisan: artisan, est_actif: false) }

    describe '.actifs' do
      it 'returns only active schedules' do
        expect(HoraireDisponibilite.actifs).to include(horaire_actif)
        expect(HoraireDisponibilite.actifs).not_to include(horaire_inactif)
      end
    end

    describe '.pour_jour' do
      let!(:horaire_lundi) { create(:horaire_disponibilite, artisan: artisan, jour: 'lundi') }
      let!(:horaire_mardi) { create(:horaire_disponibilite, artisan: artisan, jour: 'mardi') }

      it 'returns schedules for specific day' do
        expect(HoraireDisponibilite.pour_jour('lundi')).to include(horaire_lundi)
        expect(HoraireDisponibilite.pour_jour('lundi')).not_to include(horaire_mardi)
      end
    end
  end

  describe 'type validation' do
    let(:client) { create(:client) }

    it 'is invalid when associated with a client instead of an artisan' do
      horaire = build(:horaire_disponibilite, artisan: client)
      expect(horaire).not_to be_valid
      expect(horaire.errors[:artisan]).to include("doit être un artisan")
    end
  end
end
