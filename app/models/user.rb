class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum :status, {
    en_attente: "EN_ATTENTE",
    verifie: "VERIFIE",
    bloque: "BLOQUE"
  }

  # Validations
  validates :telephone, presence: true, uniqueness: true,
            format: { with: /\A\+?[1-9]\d{1,14}\z/, message: "format invalide" }
  validates :nom, presence: true
  validates :prenom, presence: true
  validates :adresse, presence: true
  validates :status, presence: true

  # Callbacks
  before_validation :set_default_status, on: :create

  private

  def set_default_status
    self.status ||= :en_attente
  end

  # Override Devise's email requirement
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end
end
