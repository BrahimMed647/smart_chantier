# Smart Chantier — Django REST API

Backend API REST pour l'application Smart Chantier.

## Stack

- Django 4.2 + Django REST Framework 3.15
- JWT via djangorestframework-simplejwt
- SQLite (dev) / PostgreSQL (prod)
- Pillow pour les images

## Installation

```bash
cd django_backend

# Créer et activer un environnement virtuel
python -m venv venv
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows

# Installer les dépendances
pip install -r requirements.txt

# Copier et configurer les variables d'environnement
cp .env.example .env

# Appliquer les migrations
python manage.py migrate

# Charger les données de démo
python manage.py seed_demo

# Démarrer le serveur
python manage.py runserver
```

## Identifiants de démo

| Email | Mot de passe | Rôle |
|-------|-------------|------|
| admin@smartms.com | admin12345 | Administrateur |
| engineer@smartms.com | engineer123 | Ingénieur |
| manager@smartms.com | manager123 | Chef de Chantier |
| accountant@smartms.com | account123 | Comptable |

## Endpoints principaux

| Méthode | URL | Description |
|---------|-----|-------------|
| POST | `/api/auth/login/` | Obtenir access + refresh tokens |
| POST | `/api/auth/refresh/` | Rafraîchir l'access token |
| GET | `/api/auth/me/` | Profil utilisateur courant |
| GET | `/api/dashboard/` | Statistiques globales |
| GET/POST | `/api/projects/` | Liste/créer projets |
| GET/PATCH | `/api/projects/{id}/` | Détail/modifier projet |
| GET | `/api/projects/{id}/budget/` | Résumé budgétaire |
| GET/POST | `/api/tasks/` | Liste/créer tâches (filtrable par projet) |
| GET/POST | `/api/reports/` | Liste/créer rapports journaliers |
| GET/POST | `/api/expenses/` | Liste/créer dépenses |
| GET/POST | `/api/alerts/` | Liste/créer alertes |
| PATCH | `/api/alerts/{id}/resolve/` | Résoudre une alerte |
| GET/POST | `/api/photos/` | Liste/uploader photos |

Tous les endpoints (sauf login/refresh) nécessitent le header :
```
Authorization: Bearer <access_token>
```

## Structure

```
django_backend/
├── config/          # Paramètres, URLs, WSGI
└── apps/
    ├── accounts/    # User, Organization + auth
    ├── projects/    # Project + dashboard
    ├── tasks/       # Task
    ├── reports/     # DailyReport
    ├── expenses/    # Expense
    ├── alerts/      # Alert
    └── photos/      # SitePhoto
```

## Production (variables d'environnement)

```env
SECRET_KEY=<clé secrète longue et aléatoire>
DEBUG=False
ALLOWED_HOSTS=votre-domaine.com
DATABASE_URL=postgres://user:password@host:5432/dbname
CORS_ALLOWED_ORIGINS=https://votre-app-flutter.com
```
