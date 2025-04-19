class CreatePortfolios < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolios, id: :uuid do |t|
      t.references :artisan, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.string :titre, null: false
      t.text :description, null: false
      t.string :image_url, null: false
      t.timestamps
    end

    add_index :portfolios, [ :artisan_id, :titre ], unique: true
  end
end
