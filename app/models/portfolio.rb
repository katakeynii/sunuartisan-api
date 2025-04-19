class Portfolio < ApplicationRecord
  # Associations
  belongs_to :artisan

  # Validations
  validates :titre, presence: true
  validates :description, presence: true
  validates :image_url, presence: true
  validate :validate_artisan_type

  # Active Storage
  has_one_attached :image

  # Callbacks
  before_save :process_image, if: :image_changed?

  private

  def validate_artisan_type
    unless artisan.is_a?(Artisan)
      errors.add(:artisan, "doit être un artisan")
    end
  end

  def process_image
    return unless image.attached?

    # Redimensionner et optimiser l'image
    image.variant(resize_to_limit: [ 800, 800 ]).processed
  end

  def image_changed?
    image.attachment&.changed?
  end
end
