class CreateAteliers < ActiveRecord::Migration[7.1]
  def change
    create_table :ateliers, id: :uuid do |t|
      t.references :artisan, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.string :nom, null: false
      t.string :adresse, null: false
      t.text :description, null: false
      t.decimal :latitude, precision: 10, scale: 8, null: false
      t.decimal :longitude, precision: 11, scale: 8, null: false
      t.timestamps
    end

    add_index :ateliers, [ :latitude, :longitude ]
    add_index :ateliers, [ :artisan_id, :nom ], unique: true
  end
end
