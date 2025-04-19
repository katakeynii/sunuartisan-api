class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table :services, id: :uuid do |t|
      t.references :metier, null: false, foreign_key: true, type: :uuid
      t.string :nom, null: false
      t.text :description, null: false
      t.decimal :prix_base, precision: 10, scale: 2, null: false
      t.timestamps
    end

    add_index :services, [:metier_id, :nom], unique: true

    create_join_table :artisans, :services, column_options: { type: :uuid } do |t|
      t.index [:artisan_id, :service_id]
      t.index [:service_id, :artisan_id]
    end
  end
end 