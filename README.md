# Smart Chantier

Application mobile et web de gestion de chantiers de construction, développée dans le cadre d'un projet de fin d'études (PFE).

---

## Aperçu

Smart Chantier permet aux entreprises de BTP de piloter leurs projets de construction en temps réel : suivi de l'avancement, rapports journaliers, alertes automatiques, gestion budgétaire et photos de chantier.

---

## Architecture

```
PFE/
├── django_backend/     # API REST (Python / Django)
└── flutter_app/        # Application mobile & web (Flutter / Dart)
```

Le backend est développé avec Django 4.2 et Django REST Framework 3.15. L'authentification repose sur JWT via djangorestframework-simplejwt. La base de données utilisée est SQLite en développement et PostgreSQL en production. Le frontend est une application Flutter 3 compatible Android, iOS et Web. La gestion d'état côté Flutter est assurée par Provider, les requêtes HTTP par Dio 5, le stockage sécurisé des tokens par flutter_secure_storage, et la navigation par go_router.

---

## Fonctionnalités

### Projets
- Liste de tous les projets avec statut, avancement et budget
- Détail d'un projet : tâches, rapports, dépenses, alertes, photos
- 5 projets de démo pré-chargés (résidentiel, commercial, infrastructure, etc.)

### Tâches
- Suivi par statut : À faire / En cours / Terminé / En retard
- Niveaux de priorité : Faible / Moyen / Élevé / Critique
- Mise à jour de l'avancement en temps réel

### Rapports journaliers
- Rapport quotidien par projet (météo, effectif, matériaux, équipements)
- Problèmes rencontrés et solutions appliquées
- Historique complet par projet

### Alertes
- Types : retard tâche, dépassement budget, sécurité, approvisionnement, réglementaire, équipement
- Niveaux : Info / Attention / Critique
- Résolution et suivi des alertes

### Budget & Dépenses
- Catégories : Matériaux, Main d'œuvre, Équipement, Transport, Sous-traitant, Autre
- Vue budgétaire par projet (budget initial vs dépenses réelles)

### Photos de chantier
- Upload de photos géolocalisées par projet
- Catégorisation par type de travaux

---

## Démarrage rapide

### Prérequis

- Python 3.10+
- Flutter 3.x (`flutter doctor` pour vérifier)
- Chrome (pour Flutter Web)

---

### 1. Backend Django

```bash
cd django_backend/django_backend

# Créer et activer l'environnement virtuel
python -m venv venv
venv\Scripts\activate          # Windows
# source venv/bin/activate     # Linux / macOS

# Installer les dépendances
pip install -r requirements.txt

# Copier la configuration
cp .env.example .env

# Appliquer les migrations (seed automatique au premier lancement)
python manage.py migrate

# Démarrer le serveur
python manage.py runserver 0.0.0.0:8000
```

> Les données de démo sont injectées automatiquement à la première migration.
> Pour les recharger manuellement : `python manage.py seed_demo`

---

### 2. Application Flutter

```bash
cd flutter_app/flutter_app

# Installer les dépendances
flutter pub get

# Lancer sur Chrome (web)
flutter run -d chrome --web-port 3000

# Lancer sur émulateur Android
flutter run -d android

# Lancer sur appareil physique (même réseau Wi-Fi)
# Modifier lib/core/constants.dart : remplacer l'IP par celle du PC
flutter run -d android
```

---

### 3. Configuration de l'URL API

Fichier : `flutter_app/flutter_app/lib/core/constants.dart`

```dart
const String _androidUrl = "http://10.0.2.2:8000/api";   // Émulateur Android
const String _webUrl     = "http://localhost:8000/api";   // Chrome / Web

// Pour un appareil physique sur le même réseau :
// const String _androidUrl = "http://192.168.X.X:8000/api";
```

---

## Comptes de démo

Quatre comptes sont disponibles après le seed :

- **Administrateur** — `admin@smartms.com` / `admin12345`
- **Ingénieur** — `engineer@smartms.com` / `engineer123`
- **Chef de Chantier** — `manager@smartms.com` / `manager123`
- **Comptable** — `accountant@smartms.com` / `account123`

---

## Données de démo

La commande `seed_demo` charge les données suivantes :

- **5 projets** : Résidence Jasmine, Centre Commercial Atlas, École Primaire El Fath, Villa Prestige Sidi Yahia, Route Nationale RN12 — Section Blida.
- **22 tâches** réparties sur les 5 projets avec des statuts variés (terminé, en cours, en retard, à faire).
- **13 rapports journaliers** couvrant plusieurs jours d'historique par projet.
- **23 dépenses** en matériaux, main d'œuvre et équipement.
- **12 alertes** de types variés : retard de tâche, dépassement de budget, sécurité, approvisionnement et réglementaire.

---

## API — Endpoints principaux

Tous les endpoints (sauf login/refresh) nécessitent le header :
```
Authorization: Bearer <access_token>
```

**Authentification**
- `POST /api/auth/login/` — Connexion, retourne access + refresh tokens
- `POST /api/auth/refresh/` — Rafraîchir l'access token
- `GET  /api/auth/me/` — Profil utilisateur courant

**Dashboard**
- `GET /api/dashboard/` — Statistiques globales

**Projets**
- `GET / POST  /api/projects/` — Liste ou créer un projet
- `GET / PATCH /api/projects/{id}/` — Détail ou modifier un projet
- `GET         /api/projects/{id}/budget/` — Résumé budgétaire

**Tâches**
- `GET / POST /api/tasks/` — Liste ou créer une tâche (filtrable par projet)
- `PATCH      /api/tasks/{id}/` — Mettre à jour une tâche

**Rapports journaliers**
- `GET / POST /api/reports/` — Liste ou créer un rapport

**Dépenses**
- `GET / POST /api/expenses/` — Liste ou créer une dépense

**Alertes**
- `GET / POST /api/alerts/` — Liste ou créer une alerte
- `PATCH      /api/alerts/{id}/resolve/` — Résoudre une alerte
- `PATCH      /api/alerts/{id}/read/` — Marquer comme lue

**Photos**
- `GET / POST /api/photos/` — Liste ou uploader une photo

---

## Structure du projet

```
django_backend/django_backend/
├── config/
│   ├── settings.py          # Configuration Django
│   ├── urls.py              # Routage principal
│   └── wsgi.py
└── apps/
    ├── accounts/            # Utilisateurs, organisations, authentification
    │   └── management/
    │       └── commands/
    │           └── seed_demo.py   # Données de démo
    ├── projects/            # Projets + dashboard
    ├── tasks/               # Tâches
    ├── reports/             # Rapports journaliers
    ├── expenses/            # Dépenses
    ├── alerts/              # Alertes
    └── photos/              # Photos de chantier

flutter_app/flutter_app/lib/
├── core/
│   ├── constants.dart       # URL API, labels traduits
│   └── theme.dart           # Thème Material Design
├── models/                  # Modèles de données Dart
├── services/
│   ├── api_service.dart     # Appels HTTP (Dio)
│   └── storage_service.dart # Stockage JWT sécurisé
├── providers/
│   └── data_provider.dart   # État global (Provider)
├── screens/
│   ├── main/                # Navigation principale
│   ├── projects/            # Liste et détail projets
│   ├── reports/             # Rapports journaliers
│   ├── alerts/              # Alertes
│   ├── photos/              # Photos chantier
│   └── profile/             # Profil utilisateur
└── widgets/                 # Composants réutilisables
```

---

## Variables d'environnement (production)

Fichier `.env` (copier depuis `.env.example`) :

```env
SECRET_KEY=<clé-secrète-longue-et-aléatoire>
DEBUG=False
ALLOWED_HOSTS=votre-domaine.com
DATABASE_URL=postgres://user:password@host:5432/dbname
CORS_ALLOWED_ORIGINS=https://votre-app-flutter.com
```

---

## Rôles utilisateurs

Cinq rôles sont définis dans l'application :

- **Administrateur** (`admin`) — accès complet à toutes les fonctionnalités.
- **Ingénieur** (`engineer`) — accès aux projets, tâches et rapports.
- **Chef de Chantier** (`site_manager`) — accès aux rapports, alertes et photos.
- **Comptable** (`accountant`) — accès aux dépenses et au budget.
- **Client** (`client`) — lecture seule.

---

## Développé avec

- [Django](https://www.djangoproject.com/) — Framework web Python
- [Django REST Framework](https://www.django-rest-framework.org/) — API REST
- [Flutter](https://flutter.dev/) — Framework UI multiplateforme
- [Dio](https://pub.dev/packages/dio) — Client HTTP Dart
- [Provider](https://pub.dev/packages/provider) — Gestion d'état Flutter

---

*Projet de Fin d'Études — Smart Chantier — Brahim*
