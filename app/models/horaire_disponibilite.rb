class HoraireDisponibilite < ApplicationRecord
  # Enums
  enum :jour, {
    lundi: "LUNDI",
    mardi: "MARDI",
    mercredi: "MERCREDI",
    jeudi: "JEUDI",
    vendredi: "VENDREDI",
    samedi: "SAMEDI",
    dimanche: "DIMANCHE"
  }

  # Associations
  belongs_to :artisan

  # Validations
  validates :jour, presence: true
  validates :heure_debut, presence: true
  validates :heure_fin, presence: true
  validates :est_actif, inclusion: { in: [ true, false ] }
  validate :heure_fin_apres_heure_debut
  validate :pas_de_chevauchement
  validate :validate_artisan_type

  # Scopes
  scope :actifs, -> { where(est_actif: true) }
  scope :pour_jour, ->(jour) { where(jour: jour) }

  private

  def validate_artisan_type
    unless artisan.is_a?(Artisan)
      errors.add(:artisan, "doit être un artisan")
    end
  end

  def heure_fin_apres_heure_debut
    return unless heure_debut && heure_fin

    if heure_fin <= heure_debut
      errors.add(:heure_fin, "doit être après l'heure de début")
    end
  end

  def pas_de_chevauchement
    return unless artisan && jour && heure_debut && heure_fin

    chevauchements = artisan.horaire_disponibilites
                           .where(jour: jour)
                           .where.not(id: id)
                           .where("heure_debut < ? AND heure_fin > ?", heure_fin, heure_debut)

    if chevauchements.exists?
      errors.add(:base, "chevauche un autre horaire de disponibilité")
    end
  end
end
