class RequeteService < ApplicationRecord
  # Enums
  enum status: {
    en_attente: "EN_ATTENTE",
    accepte: "ACCEPTE",
    en_cours: "EN_COURS",
    termine: "TERMINE",
    annule: "ANNULE"
  }

  # Associations
  belongs_to :client
  has_many :offres, dependent: :destroy
  has_one :transaction, dependent: :destroy
  has_many :evaluations
  has_and_belongs_to_many :services

  # Validations
  validates :description, presence: true
  validates :budget_estime, presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :date_souhaitee, presence: true
  validates :status, presence: true
  validates :latitude, presence: true,
            numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true,
            numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  # Scopes
  scope :ouverts, -> { where(est_ouvert: true, status: :en_attente) }
  scope :en_cours, -> { where(status: [ :accepte, :en_cours ]) }
  scope :termines, -> { where(status: :termine) }

  # Callbacks
  before_validation :set_default_status, on: :create

  private

  def set_default_status
    self.status ||= :en_attente
  end
end
