class DisponibiliteExceptionnelle < ApplicationRecord
  # Associations
  belongs_to :artisan

  # Validations
  validates :date_debut, presence: true
  validates :date_fin, presence: true
  validates :raison, presence: true
  validates :est_disponible, inclusion: { in: [ true, false ] }
  validate :date_fin_apres_date_debut
  validate :pas_de_chevauchement
  validate :validate_artisan_type

  # Scopes
  scope :actives, -> { where("date_fin >= ?", Time.current) }
  scope :a_venir, -> { where("date_debut > ?", Time.current) }
  scope :en_cours, -> { where("date_debut <= ? AND date_fin >= ?", Time.current, Time.current) }

  private

  def validate_artisan_type
    unless artisan.is_a?(Artisan)
      errors.add(:artisan, "doit être un artisan")
    end
  end

  def date_fin_apres_date_debut
    return unless date_debut && date_fin

    if date_fin <= date_debut
      errors.add(:date_fin, "doit être après la date de début")
    end
  end

  def pas_de_chevauchement
    return unless artisan && date_debut && date_fin

    chevauchements = artisan.disponibilite_exceptionnelles
                           .where.not(id: id)
                           .where("date_debut < ? AND date_fin > ?", date_fin, date_debut)

    if chevauchements.exists?
      errors.add(:base, "chevauche une autre disponibilité exceptionnelle")
    end
  end
end
