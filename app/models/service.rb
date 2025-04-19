class Service < ApplicationRecord
  # Associations
  belongs_to :metier
  has_and_belongs_to_many :artisans
  has_and_belongs_to_many :requete_services

  # Validations
  validates :nom, presence: true
  validates :description, presence: true
  validates :prix_base, presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :by_metier, ->(metier_id) { where(metier_id: metier_id) }
  scope :active, -> { joins(:artisans).where(artisans: { verified: true }).distinct }
end
