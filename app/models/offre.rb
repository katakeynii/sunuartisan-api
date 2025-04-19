class Offre < ApplicationRecord
  # Associations
  belongs_to :artisan
  belongs_to :requete_service

  # Validations
  validates :prix_propose, presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true
  validates :necessite_deplacement, inclusion: { in: [ true, false ] }
  validate :validate_artisan_type

  # Scopes
  scope :en_attente, -> { joins(:requete_service).where(requete_services: { status: :en_attente }) }
  scope :acceptees, -> { joins(:requete_service).where(requete_services: { status: [ :accepte, :en_cours ] }) }

  # Instance methods
  def accepter
    RequeteService.transaction do
      requete_service.update!(status: :accepte)
      # Créer une transaction si nécessaire
      Transaction.create!(
        requete_service: requete_service,
        montant: prix_propose,
        reference: generate_reference
      )
    end
  end

  def refuser
    update!(refusee: true)
  end

  private

  def validate_artisan_type
    unless artisan.is_a?(Artisan)
      errors.add(:artisan, "doit être un artisan")
    end
  end

  def generate_reference
    "OFF#{Time.current.to_i}#{SecureRandom.hex(3).upcase}"
  end
end
