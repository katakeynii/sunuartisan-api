# SunuArtisan API

## Couverture des Tests

### Vue d'ensemble
- Couverture globale : 63.57% (164/258 lignes)
- Nombre total de tests : 65
- Tests réussis : 27
- Tests échoués : 38

### Détails des Tests par Modèle

#### Artisan
- Validations
  - Présence et unicité du numéro CNI
  - Présence du téléphone, nom et prénom
- Associations
  - Portfolios (has_many)
  - Horaires de disponibilité (has_many)
  - Disponibilités exceptionnelles (has_many)
  - Ateliers (has_many)
  - Offres (has_many)
  - Évaluations (has_many)
  - Métiers (has_and_belongs_to_many)
  - Services (has_and_belongs_to_many)
- Scopes
  - Artisans vérifiés
  - Artisans disponibles
- Méthodes d'instance
  - Calcul de la note moyenne
  - Vérification de la disponibilité
- Pièces jointes
  - Photo CNI
  - Photo de profil

#### Client
- Validations
  - Présence du téléphone, nom, prénom et email
  - Format de l'email
- Associations
  - Requêtes de service (has_many)
  - Évaluations (has_many through)
- Validations de type
  - Ne peut pas être associé comme artisan

#### HoraireDisponibilite
- Validations
  - Présence du jour, heure de début et heure de fin
  - Association avec un artisan
- Validations personnalisées
  - Heure de fin après heure de début
  - Pas de chevauchement
- Scopes
  - Horaires actifs
  - Filtrage par jour

#### DisponibiliteExceptionnelle
- Validations
  - Présence des dates de début et fin
  - Présence de la raison
  - Association avec un artisan
- Validations personnalisées
  - Date de fin après date de début
  - Pas de chevauchement
- Scopes
  - Disponibilités futures
  - Disponibilités passées
  - Disponibilités courantes

### Erreurs à Corriger
1. Problème avec Faker::IDNumber dans les factories
2. Problème avec les enums dans les modèles
3. Tables de jointure manquantes pour les associations has_and_belongs_to_many
4. Problèmes de validation des associations de type

### Prochaines Étapes
1. Corriger les erreurs de factory avec Faker
2. Créer les tables de jointure manquantes
3. Corriger les définitions d'enum dans les modèles
4. Ajouter les validations de type manquantes
