class Metier < ApplicationRecord
  # Associations
  has_and_belongs_to_many :artisans
  has_many :services, dependent: :destroy

  # Validations
  validates :nom, presence: true, uniqueness: true
  validates :description, presence: true

  # Scopes
  scope :active, -> { joins(:artisans).where(artisans: { verified: true }).distinct }
end
