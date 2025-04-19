class CreateMetiers < ActiveRecord::Migration[7.1]
  def change
    create_table :metiers, id: :uuid do |t|
      t.string :nom, null: false
      t.text :description, null: false
      t.timestamps
    end

    add_index :metiers, :nom, unique: true

    create_join_table :artisans, :metiers, column_options: { type: :uuid } do |t|
      t.index [ :artisan_id, :metier_id ]
      t.index [ :metier_id, :artisan_id ]
    end
  end
end
