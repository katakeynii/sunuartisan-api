require 'rails_helper'

RSpec.describe Artisan, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:cni_numero) }
    it { should validate_uniqueness_of(:cni_numero) }
    it { should validate_presence_of(:telephone) }
    it { should validate_presence_of(:nom) }
    it { should validate_presence_of(:prenom) }
  end

  describe 'associations' do
    it { should have_many(:portfolios).dependent(:destroy) }
    it { should have_many(:horaire_disponibilites).dependent(:destroy) }
    it { should have_many(:disponibilite_exceptionnelles).dependent(:destroy) }
    it { should have_many(:ateliers).dependent(:destroy) }
    it { should have_many(:offres).dependent(:destroy) }
    it { should have_many(:evaluations).dependent(:destroy) }
    it { should have_and_belong_to_many(:metiers) }
    it { should have_and_belong_to_many(:services) }
  end

  describe 'scopes' do
    let!(:artisan_verifie) { create(:artisan, :verified) }
    let!(:artisan_non_verifie) { create(:artisan) }

    it 'verified scope returns only verified artisans' do
      expect(Artisan.verified).to include(artisan_verifie)
      expect(Artisan.verified).not_to include(artisan_non_verifie)
    end

    it 'available scope returns only available artisans' do
      artisan_verifie.update(est_disponible: true)
      artisan_non_verifie.update(est_disponible: false)
      expect(Artisan.available).to include(artisan_verifie)
      expect(Artisan.available).not_to include(artisan_non_verifie)
    end
  end

  describe '#note_moyenne' do
    let(:artisan) { create(:artisan) }

    context 'when artisan has evaluations' do
      before do
        create(:evaluation, artisan: artisan, note: 4)
        create(:evaluation, artisan: artisan, note: 5)
      end

      it 'returns the average of evaluation notes' do
        expect(artisan.note_moyenne).to eq(4.5)
      end
    end

    context 'when artisan has no evaluations' do
      it 'returns 0' do
        expect(artisan.note_moyenne).to eq(0)
      end
    end
  end

  describe '#disponible?' do
    let(:artisan) { create(:artisan, :verified) }

    context 'when artisan is not verified' do
      let(:artisan) { create(:artisan) }

      it 'returns false' do
        expect(artisan.disponible?).to be false
      end
    end

    context 'when artisan has active exceptional unavailability' do
      before do
        create(:disponibilite_exceptionnelle,
               artisan: artisan,
               date_debut: Time.current - 1.hour,
               date_fin: Time.current + 1.hour,
               est_disponible: false)
      end

      it 'returns false' do
        expect(artisan.disponible?).to be false
      end
    end

    context 'when artisan has active availability for current time' do
      before do
        create(:horaire_disponibilite,
               artisan: artisan,
               jour: Time.current.strftime("%A").downcase,
               heure_debut: "00:00",
               heure_fin: "23:59")
      end

      it 'returns true' do
        expect(artisan.disponible?).to be true
      end
    end
  end

  describe 'attachments' do
    let(:artisan) { build(:artisan, :with_photos) }

    it 'can have a CNI photo attached' do
      expect(artisan.cni_photo).to be_attached
    end

    it 'can have a profile photo attached' do
      expect(artisan.profile_photo).to be_attached
    end
  end
end
