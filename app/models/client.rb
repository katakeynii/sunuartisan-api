class Client < User
  # Additional validations for Client
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            if: :email_present?

  # Associations
  has_many :requete_services, dependent: :destroy
  has_many :evaluations, through: :requete_services

  # Override email requirement for clients
  def email_required?
    true
  end

  def email_changed?
    true
  end

  def will_save_change_to_email?
    true
  end

  private

  def email_present?
    email.present?
  end
end
