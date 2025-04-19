class CreateRequeteServices < ActiveRecord::Migration[7.1]
  def change
    create_table :requete_services, id: :uuid do |t|
      t.references :client, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.text :description, null: false
      t.decimal :budget_estime, precision: 10, scale: 2, null: false
      t.datetime :date_souhaitee, null: false
      t.string :status, null: false, default: 'EN_ATTENTE'
      t.boolean :est_ouvert, default: true, null: false
      t.decimal :latitude, precision: 10, scale: 8, null: false
      t.decimal :longitude, precision: 11, scale: 8, null: false
      t.timestamps
    end

    add_index :requete_services, :status
    add_index :requete_services, [ :latitude, :longitude ]
    add_index :requete_services, [ :client_id, :status ]

    create_join_table :requete_services, :services, column_options: { type: :uuid } do |t|
      t.index [ :requete_service_id, :service_id ]
      t.index [ :service_id, :requete_service_id ]
    end
  end
end
