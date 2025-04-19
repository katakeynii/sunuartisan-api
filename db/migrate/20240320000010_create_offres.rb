class CreateOffres < ActiveRecord::Migration[7.1]
  def change
    create_table :offres, id: :uuid do |t|
      t.references :artisan, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :requete_service, null: false, foreign_key: { to_table: :requete_services }, type: :uuid
      t.decimal :prix_propose, precision: 10, scale: 2, null: false
      t.text :description, null: false
      t.boolean :necessite_deplacement, default: false, null: false
      t.boolean :refusee, default: false, null: false
      t.timestamps
    end

    add_index :offres, [ :artisan_id, :requete_service_id ], unique: true
    add_index :offres, [ :requete_service_id, :refusee ]
  end
end
