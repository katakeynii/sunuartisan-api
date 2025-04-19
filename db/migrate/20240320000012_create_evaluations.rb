class CreateEvaluations < ActiveRecord::Migration[7.1]
  def change
    create_table :evaluations, id: :uuid do |t|
      t.references :artisan, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :requete_service, foreign_key: true, type: :uuid
      t.integer :note, null: false
      t.text :commentaire, null: false
      t.timestamps
    end

    add_index :evaluations, [ :artisan_id, :requete_service_id ], unique: true,
              where: "requete_service_id IS NOT NULL"
  end
end
