class CreateDisponibiliteExceptionnelles < ActiveRecord::Migration[7.1]
  def change
    create_table :disponibilite_exceptionnelles, id: :uuid do |t|
      t.references :artisan, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.datetime :date_debut, null: false
      t.datetime :date_fin, null: false
      t.text :raison, null: false
      t.boolean :est_disponible, default: false, null: false
      t.timestamps
    end

    add_index :disponibilite_exceptionnelles, [ :artisan_id, :date_debut, :date_fin ],
              name: 'index_disponibilite_exceptionnelles_dates'
  end
end
