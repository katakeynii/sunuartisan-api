# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_03_20_000013) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "artisans_metiers", id: false, force: :cascade do |t|
    t.uuid "artisan_id", null: false
    t.uuid "metier_id", null: false
    t.index ["artisan_id", "metier_id"], name: "index_artisans_metiers_on_artisan_id_and_metier_id"
    t.index ["metier_id", "artisan_id"], name: "index_artisans_metiers_on_metier_id_and_artisan_id"
  end

  create_table "artisans_services", id: false, force: :cascade do |t|
    t.uuid "artisan_id", null: false
    t.uuid "service_id", null: false
    t.index ["artisan_id", "service_id"], name: "index_artisans_services_on_artisan_id_and_service_id"
    t.index ["service_id", "artisan_id"], name: "index_artisans_services_on_service_id_and_artisan_id"
  end

  create_table "ateliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "artisan_id", null: false
    t.string "nom", null: false
    t.string "adresse", null: false
    t.text "description", null: false
    t.decimal "latitude", precision: 10, scale: 8, null: false
    t.decimal "longitude", precision: 11, scale: 8, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artisan_id", "nom"], name: "index_ateliers_on_artisan_id_and_nom", unique: true
    t.index ["artisan_id"], name: "index_ateliers_on_artisan_id"
    t.index ["latitude", "longitude"], name: "index_ateliers_on_latitude_and_longitude"
  end

  create_table "disponibilite_exceptionnelles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "artisan_id", null: false
    t.datetime "date_debut", null: false
    t.datetime "date_fin", null: false
    t.text "raison", null: false
    t.boolean "est_disponible", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artisan_id", "date_debut", "date_fin"], name: "index_disponibilite_exceptionnelles_dates"
    t.index ["artisan_id"], name: "index_disponibilite_exceptionnelles_on_artisan_id"
  end

  create_table "evaluations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "artisan_id", null: false
    t.uuid "requete_service_id"
    t.integer "note", null: false
    t.text "commentaire", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artisan_id", "requete_service_id"], name: "index_evaluations_on_artisan_id_and_requete_service_id", unique: true, where: "(requete_service_id IS NOT NULL)"
    t.index ["artisan_id"], name: "index_evaluations_on_artisan_id"
    t.index ["requete_service_id"], name: "index_evaluations_on_requete_service_id"
  end

  create_table "horaire_disponibilites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "artisan_id", null: false
    t.string "jour", null: false
    t.time "heure_debut", null: false
    t.time "heure_fin", null: false
    t.boolean "est_actif", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artisan_id", "jour", "heure_debut", "heure_fin"], name: "index_horaire_disponibilites_unicite", unique: true
    t.index ["artisan_id"], name: "index_horaire_disponibilites_on_artisan_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "metiers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "nom", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nom"], name: "index_metiers_on_nom", unique: true
  end

  create_table "offres", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "artisan_id", null: false
    t.uuid "requete_service_id", null: false
    t.decimal "prix_propose", precision: 10, scale: 2, null: false
    t.text "description", null: false
    t.boolean "necessite_deplacement", default: false, null: false
    t.boolean "refusee", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artisan_id", "requete_service_id"], name: "index_offres_on_artisan_id_and_requete_service_id", unique: true
    t.index ["artisan_id"], name: "index_offres_on_artisan_id"
    t.index ["requete_service_id", "refusee"], name: "index_offres_on_requete_service_id_and_refusee"
    t.index ["requete_service_id"], name: "index_offres_on_requete_service_id"
  end

  create_table "portfolios", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "artisan_id", null: false
    t.string "titre", null: false
    t.text "description", null: false
    t.string "image_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artisan_id", "titre"], name: "index_portfolios_on_artisan_id_and_titre", unique: true
    t.index ["artisan_id"], name: "index_portfolios_on_artisan_id"
  end

  create_table "requete_services", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "client_id", null: false
    t.text "description", null: false
    t.decimal "budget_estime", precision: 10, scale: 2, null: false
    t.datetime "date_souhaitee", null: false
    t.string "status", default: "EN_ATTENTE", null: false
    t.boolean "est_ouvert", default: true, null: false
    t.decimal "latitude", precision: 10, scale: 8, null: false
    t.decimal "longitude", precision: 11, scale: 8, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "status"], name: "index_requete_services_on_client_id_and_status"
    t.index ["client_id"], name: "index_requete_services_on_client_id"
    t.index ["latitude", "longitude"], name: "index_requete_services_on_latitude_and_longitude"
    t.index ["status"], name: "index_requete_services_on_status"
  end

  create_table "requete_services_services", id: false, force: :cascade do |t|
    t.uuid "requete_service_id", null: false
    t.uuid "service_id", null: false
    t.index ["requete_service_id", "service_id"], name: "idx_on_requete_service_id_service_id_986131e01a"
    t.index ["service_id", "requete_service_id"], name: "idx_on_service_id_requete_service_id_965dfb1899"
  end

  create_table "services", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "metier_id", null: false
    t.string "nom", null: false
    t.text "description", null: false
    t.decimal "prix_base", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metier_id", "nom"], name: "index_services_on_metier_id_and_nom", unique: true
    t.index ["metier_id"], name: "index_services_on_metier_id"
  end

  create_table "transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "requete_service_id", null: false
    t.decimal "montant", precision: 10, scale: 2, null: false
    t.string "reference", null: false
    t.boolean "est_complete", default: false, null: false
    t.datetime "date_paiement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "index_transactions_on_reference", unique: true
    t.index ["requete_service_id", "est_complete"], name: "index_transactions_on_requete_service_id_and_est_complete"
    t.index ["requete_service_id"], name: "index_transactions_on_requete_service_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "telephone", null: false
    t.string "nom", null: false
    t.string "prenom", null: false
    t.string "adresse", null: false
    t.string "type", null: false
    t.string "status", default: "EN_ATTENTE", null: false
    t.string "cni_numero"
    t.boolean "verified", default: false
    t.boolean "est_disponible", default: true
    t.float "note_moyenne", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cni_numero"], name: "index_users_on_cni_numero", unique: true, where: "(cni_numero IS NOT NULL)"
    t.index ["email"], name: "index_users_on_email", unique: true, where: "(email IS NOT NULL)"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, where: "(reset_password_token IS NOT NULL)"
    t.index ["telephone"], name: "index_users_on_telephone", unique: true
    t.index ["type", "verified"], name: "index_users_on_type_and_verified"
    t.index ["type"], name: "index_users_on_type"
  end

  add_foreign_key "ateliers", "users", column: "artisan_id"
  add_foreign_key "disponibilite_exceptionnelles", "users", column: "artisan_id"
  add_foreign_key "evaluations", "requete_services"
  add_foreign_key "evaluations", "users", column: "artisan_id"
  add_foreign_key "horaire_disponibilites", "users", column: "artisan_id"
  add_foreign_key "offres", "requete_services"
  add_foreign_key "offres", "users", column: "artisan_id"
  add_foreign_key "portfolios", "users", column: "artisan_id"
  add_foreign_key "requete_services", "users", column: "client_id"
  add_foreign_key "services", "metiers"
  add_foreign_key "transactions", "requete_services"
end
