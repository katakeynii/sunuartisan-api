require 'rails_helper'

RSpec.describe DisponibiliteExceptionnelle, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:date_debut) }
    it { should validate_presence_of(:date_fin) }
    it { should validate_presence_of(:raison) }
    it { should belong_to(:artisan) }
  end

  describe 'custom validations' do
    let(:artisan) { create(:artisan) }

    context 'date_fin_apres_date_debut' do
      it 'is valid when end date is after start date' do
        disponibilite = build(:disponibilite_exceptionnelle,
                            artisan: artisan,
                            date_debut: Date.today,
                            date_fin: Date.today + 1.day)
        expect(disponibilite).to be_valid
      end

      it 'is invalid when end date is before start date' do
        disponibilite = build(:disponibilite_exceptionnelle,
                            artisan: artisan,
                            date_debut: Date.today,
                            date_fin: Date.today - 1.day)
        expect(disponibilite).not_to be_valid
        expect(disponibilite.errors[:date_fin]).to include("doit être après la date de début")
      end

      it 'is valid when end date equals start date' do
        disponibilite = build(:disponibilite_exceptionnelle,
                            artisan: artisan,
                            date_debut: Date.today,
                            date_fin: Date.today)
        expect(disponibilite).to be_valid
      end
    end

    context 'pas_de_chevauchement' do
      let!(:existing_disponibilite) do
        create(:disponibilite_exceptionnelle,
               artisan: artisan,
               date_debut: Date.today,
               date_fin: Date.today + 5.days)
      end

      it 'is valid when there is no overlap' do
        disponibilite = build(:disponibilite_exceptionnelle,
                            artisan: artisan,
                            date_debut: Date.today + 6.days,
                            date_fin: Date.today + 10.days)
        expect(disponibilite).to be_valid
      end

      it 'is invalid when there is overlap' do
        disponibilite = build(:disponibilite_exceptionnelle,
                            artisan: artisan,
                            date_debut: Date.today + 3.days,
                            date_fin: Date.today + 7.days)
        expect(disponibilite).not_to be_valid
        expect(disponibilite.errors[:base]).to include("chevauche une autre disponibilité exceptionnelle")
      end
    end
  end

  describe 'scopes' do
    let(:artisan) { create(:artisan) }
    let!(:disponibilite_future) do
      create(:disponibilite_exceptionnelle,
             artisan: artisan,
             date_debut: Date.today + 1.day,
             date_fin: Date.today + 5.days)
    end
    let!(:disponibilite_passee) do
      create(:disponibilite_exceptionnelle,
             artisan: artisan,
             date_debut: Date.today - 5.days,
             date_fin: Date.today - 1.day)
    end
    let!(:disponibilite_courante) do
      create(:disponibilite_exceptionnelle,
             artisan: artisan,
             date_debut: Date.today - 1.day,
             date_fin: Date.today + 1.day)
    end

    describe '.futures' do
      it 'returns only future availabilities' do
        expect(DisponibiliteExceptionnelle.futures).to include(disponibilite_future)
        expect(DisponibiliteExceptionnelle.futures).not_to include(disponibilite_passee)
        expect(DisponibiliteExceptionnelle.futures).not_to include(disponibilite_courante)
      end
    end

    describe '.passees' do
      it 'returns only past availabilities' do
        expect(DisponibiliteExceptionnelle.passees).to include(disponibilite_passee)
        expect(DisponibiliteExceptionnelle.passees).not_to include(disponibilite_future)
        expect(DisponibiliteExceptionnelle.passees).not_to include(disponibilite_courante)
      end
    end

    describe '.courantes' do
      it 'returns only current availabilities' do
        expect(DisponibiliteExceptionnelle.courantes).to include(disponibilite_courante)
        expect(DisponibiliteExceptionnelle.courantes).not_to include(disponibilite_future)
        expect(DisponibiliteExceptionnelle.courantes).not_to include(disponibilite_passee)
      end
    end
  end

  describe 'type validation' do
    let(:client) { create(:client) }

    it 'is invalid when associated with a client instead of an artisan' do
      disponibilite = build(:disponibilite_exceptionnelle, artisan: client)
      expect(disponibilite).not_to be_valid
      expect(disponibilite.errors[:artisan]).to include("doit être un artisan")
    end
  end
end
