class Evaluation < ApplicationRecord
  # Associations
  belongs_to :artisan
  belongs_to :requete_service, optional: true

  # Validations
  validates :note, presence: true,
            numericality: { only_integer: true,
                          greater_than_or_equal_to: 1,
                          less_than_or_equal_to: 5 }
  validates :commentaire, presence: true, length: { minimum: 10, maximum: 500 }
  validate :requete_service_terminee, if: :requete_service_present?
  validate :validate_artisan_type

  # Callbacks
  after_save :update_artisan_note_moyenne

  private

  def validate_artisan_type
    unless artisan.is_a?(Artisan)
      errors.add(:artisan, "doit être un artisan")
    end
  end

  def requete_service_terminee
    unless requete_service.termine?
      errors.add(:requete_service, "doit être terminée pour pouvoir évaluer")
    end
  end

  def requete_service_present?
    requete_service.present?
  end

  def update_artisan_note_moyenne
    artisan.update_column(:note_moyenne, artisan.evaluations.average(:note))
  end
end
