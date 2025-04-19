class Atelier < ApplicationRecord
  # Associations
  belongs_to :artisan

  # Validations
  validates :nom, presence: true
  validates :adresse, presence: true
  validates :description, presence: true
  validates :latitude, presence: true,
            numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true,
            numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validate :validate_artisan_type

  # Scopes
  scope :actifs, -> { joins(:artisan).where(artisans: { verified: true }) }

  # Géolocalisation
  def distance_to(lat, lon)
    # Formule de Haversine pour calculer la distance entre deux points géographiques
    r = 6371 # Rayon de la Terre en km

    dlat = (lat - latitude) * Math::PI / 180
    dlon = (lon - longitude) * Math::PI / 180

    a = Math.sin(dlat/2) * Math.sin(dlat/2) +
        Math.cos(latitude * Math::PI / 180) * Math.cos(lat * Math::PI / 180) *
        Math.sin(dlon/2) * Math.sin(dlon/2)

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    r * c
  end

  private

  def validate_artisan_type
    unless artisan.is_a?(Artisan)
      errors.add(:artisan, "doit être un artisan")
    end
  end
end
