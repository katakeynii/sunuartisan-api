class CreateHoraireDisponibilites < ActiveRecord::Migration[7.1]
  def change
    create_table :horaire_disponibilites, id: :uuid do |t|
      t.references :artisan, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.string :jour, null: false
      t.time :heure_debut, null: false
      t.time :heure_fin, null: false
      t.boolean :est_actif, default: true, null: false
      t.timestamps
    end

    add_index :horaire_disponibilites, [ :artisan_id, :jour, :heure_debut, :heure_fin ],
              unique: true,
              name: 'index_horaire_disponibilites_unicite'
  end
end
