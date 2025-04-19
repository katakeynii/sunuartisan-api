class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.references :requete_service, null: false, foreign_key: true, type: :uuid
      t.decimal :montant, precision: 10, scale: 2, null: false
      t.string :reference, null: false
      t.boolean :est_complete, default: false, null: false
      t.datetime :date_paiement
      t.timestamps
    end

    add_index :transactions, :reference, unique: true
    add_index :transactions, [ :requete_service_id, :est_complete ]
  end
end
