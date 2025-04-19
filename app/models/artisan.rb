class Artisan < User
  # Associations
  has_many :portfolios, dependent: :destroy
  has_many :horaire_disponibilites, dependent: :destroy
  has_many :disponibilite_exceptionnelles, dependent: :destroy
  has_many :ateliers, dependent: :destroy
  has_many :offres, dependent: :destroy
  has_many :evaluations, dependent: :destroy

  has_and_belongs_to_many :metiers
  has_and_belongs_to_many :services

  # Validations
  validates :cni_numero, presence: true, uniqueness: true
  validates :cni_photo, presence: true
  validates :profile_photo, presence: true

  # Active Storage
  has_one_attached :cni_photo
  has_one_attached :profile_photo

  # Scopes
  scope :verified, -> { where(verified: true) }
  scope :available, -> { where(est_disponible: true) }

  # Instance methods
  def note_moyenne
    evaluations.average(:note) || 0
  end

  def disponible?
    return false unless verified?
    return false if disponibilite_exceptionnelle_active?
    horaire_disponible?
  end

  private

  def disponibilite_exceptionnelle_active?
    disponibilite_exceptionnelles
      .where("date_debut <= ? AND date_fin >= ?", Time.current, Time.current)
      .where(est_disponible: false)
      .exists?
  end

  def horaire_disponible?
    current_time = Time.current
    current_day = current_time.strftime("%A").downcase

    horaire_disponibilites
      .where(jour: current_day, est_actif: true)
      .where("heure_debut <= ? AND heure_fin >= ?", current_time, current_time)
      .exists?
  end
end
