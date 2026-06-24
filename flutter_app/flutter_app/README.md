# Smart Chantier — Flutter App

Application mobile Flutter pour la gestion de chantiers.

## Prérequis

- Flutter SDK 3.x ([flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install))
- Android Studio ou VS Code avec l'extension Flutter
- Émulateur Android ou appareil physique

## Démarrage rapide

```bash
cd flutter_app

# Installer les dépendances
flutter pub get

# Lancer sur émulateur
flutter run
```

## Configuration du backend

Modifiez `lib/core/constants.dart` :

```dart
// Émulateur Android (pointe vers 127.0.0.1 de l'hôte)
const String kBaseUrl = "http://127.0.0.1:8000/api";

// Appareil physique sur le même réseau
const String kBaseUrl = "http://192.168.100.250:8000/api";

// Production
const String kBaseUrl = "https://votre-domaine.com/api";
```

## Structure

```
lib/
├── main.dart                  # Point d'entrée, routing auth
├── core/
│   ├── constants.dart         # URL API, labels
│   └── theme.dart             # Thème Material 3 (navy + orange)
├── models/                    # Data models (fromJson/toJson)
├── services/
│   ├── api_service.dart       # Client Dio + JWT auto-refresh
│   └── storage_service.dart   # flutter_secure_storage
├── providers/
│   ├── auth_provider.dart     # État d'authentification
│   └── data_provider.dart     # Données (projets, tâches, etc.)
└── screens/
    ├── login/
    ├── main/                  # Bottom nav (5 onglets)
    ├── dashboard/
    ├── projects/              # Liste + détail (5 onglets)
    ├── reports/               # Liste + formulaire d'ajout
    ├── expenses/              # Budget + ajout dépense
    ├── photos/                # Grille + capture
    ├── alerts/                # Onglets non lues/lues/résolues
    └── profile/
```

## Fonctionnalités

- Connexion JWT avec refresh automatique
- Tableau de bord avec stats globales et budget
- Liste projets avec recherche et filtres par statut
- Détail projet — 5 onglets (Aperçu, Tâches, Rapports, Dépenses, Alertes)
- Ajout rapport journalier avec formulaire complet
- Gestion des dépenses avec répartition budgétaire
- Photos chantier via caméra ou galerie
- Alertes par niveau (critique/attention/info)
- Profil utilisateur avec rôle et statistiques
