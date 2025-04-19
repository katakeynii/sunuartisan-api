require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:telephone) }
    it { should validate_presence_of(:nom) }
    it { should validate_presence_of(:prenom) }
    it { should validate_presence_of(:email) }

    context 'email format' do
      it 'should be valid with correct email format' do
        client = build(:client, email: 'test@example.com')
        expect(client).to be_valid
      end

      it 'should be invalid with incorrect email format' do
        client = build(:client, email: 'invalid_email')
        expect(client).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { should have_many(:requete_services).dependent(:destroy) }
    it { should have_many(:evaluations).through(:requete_services) }
  end

  describe 'devise overrides' do
    let(:client) { build(:client) }

    it 'requires email' do
      expect(client.email_required?).to be true
    end

    it 'tracks email changes' do
      expect(client.email_changed?).to be true
    end

    it 'will save email changes' do
      expect(client.will_save_change_to_email?).to be true
    end
  end

  describe 'type checking' do
    let(:client) { create(:client) }
    let(:atelier) { build(:atelier, artisan: client) }
    let(:horaire) { build(:horaire_disponibilite, artisan: client) }
    let(:disponibilite) { build(:disponibilite_exceptionnelle, artisan: client) }
    let(:offre) { build(:offre, artisan: client) }
    let(:portfolio) { build(:portfolio, artisan: client) }
    let(:evaluation) { build(:evaluation, artisan: client) }

    it 'cannot be associated as an artisan in atelier' do
      expect(atelier).not_to be_valid
      expect(atelier.errors[:artisan]).to include("doit être un artisan")
    end

    it 'cannot be associated as an artisan in horaire_disponibilite' do
      expect(horaire).not_to be_valid
      expect(horaire.errors[:artisan]).to include("doit être un artisan")
    end

    it 'cannot be associated as an artisan in disponibilite_exceptionnelle' do
      expect(disponibilite).not_to be_valid
      expect(disponibilite.errors[:artisan]).to include("doit être un artisan")
    end

    it 'cannot be associated as an artisan in offre' do
      expect(offre).not_to be_valid
      expect(offre.errors[:artisan]).to include("doit être un artisan")
    end

    it 'cannot be associated as an artisan in portfolio' do
      expect(portfolio).not_to be_valid
      expect(portfolio.errors[:artisan]).to include("doit être un artisan")
    end

    it 'cannot be associated as an artisan in evaluation' do
      expect(evaluation).not_to be_valid
      expect(evaluation.errors[:artisan]).to include("doit être un artisan")
    end
  end
end
