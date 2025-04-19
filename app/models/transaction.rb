class Transaction < ApplicationRecord
  # Associations
  belongs_to :requete_service

  # Validations
  validates :montant, presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :reference, presence: true, uniqueness: true
  validates :est_complete, inclusion: { in: [ true, false ] }

  # Callbacks
  before_validation :generate_reference, on: :create
  after_create :bloquer_montant
  after_update :debloquer_paiement, if: :devient_complete?

  # Scopes
  scope :en_attente, -> { where(est_complete: false) }
  scope :completees, -> { where(est_complete: true) }

  private

  def generate_reference
    self.reference ||= "TRX#{Time.current.to_i}#{SecureRandom.hex(3).upcase}"
  end

  def bloquer_montant
    # Intégration avec le service de paiement pour bloquer le montant
    # À implémenter avec le provider de paiement choisi
  end

  def debloquer_paiement
    # Intégration avec le service de paiement pour débloquer le paiement vers l'artisan
    # À implémenter avec le provider de paiement choisi
  end

  def devient_complete?
    saved_change_to_est_complete? && est_complete?
  end
end
