class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      # Devise fields
      t.string :email
      t.string :encrypted_password
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      # Custom fields
      t.string :telephone, null: false
      t.string :nom, null: false
      t.string :prenom, null: false
      t.string :adresse, null: false
      t.string :type, null: false  # Pour STI (Client/Artisan)
      t.string :status, null: false, default: 'EN_ATTENTE'

      # Artisan specific fields
      t.string :cni_numero
      t.boolean :verified, default: false
      t.boolean :est_disponible, default: true
      t.float :note_moyenne, default: 0.0

      t.timestamps
    end

    add_index :users, :email, unique: true, where: "email IS NOT NULL"
    add_index :users, :reset_password_token, unique: true, where: "reset_password_token IS NOT NULL"
    add_index :users, :telephone, unique: true
    add_index :users, :type
    add_index :users, [ :type, :verified ]
    add_index :users, :cni_numero, unique: true, where: "cni_numero IS NOT NULL"
  end
end
