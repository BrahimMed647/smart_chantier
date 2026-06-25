import "package:flutter/foundation.dart";

// ============================================================
// CONFIGURATION DE L'URL DE L'API
// ============================================================
//
// Pour passer de LOCAL a PRODUCTION :
//   Mets kUseProduction = true  avant de builder l'APK
//
// Pour developper en local :
//   Mets kUseProduction = false
//
// ============================================================

// Change to false when developing locally
const bool kUseProduction = true;

// Your Railway backend URL
const String kProductionUrl = "https://smartchantier-production.up.railway.app/api";

// Local development URLs
const String _androidEmulatorUrl = "http://10.0.2.2:8000/api";
const String _webLocalUrl = "http://localhost:8000/api";

// The URL the app actually uses
final String kBaseUrl = kUseProduction
    ? kProductionUrl
    : (kIsWeb ? _webLocalUrl : _androidEmulatorUrl);

// ============================================================
// LABELS — French translations
// ============================================================

const Map<String, String> kRoleLabels = {
  "admin": "Administrateur",
  "user_admin": "Admin Utilisateurs",
  "engineer": "Ingenieur",
  "site_manager": "Chef de Chantier",
  "accountant": "Comptable",
  "client": "Client / Maitre d'Ouvrage",
};

const Map<String, String> kProjectStatusLabels = {
  "planned": "Planifie",
  "in_progress": "En cours",
  "on_hold": "En pause",
  "delayed": "En retard",
  "completed": "Termine",
  "cancelled": "Annule",
};

const Map<String, String> kTaskStatusLabels = {
  "todo": "A faire",
  "in_progress": "En cours",
  "done": "Termine",
  "delayed": "En retard",
  "cancelled": "Annule",
};

const Map<String, String> kTaskPriorityLabels = {
  "low": "Faible",
  "medium": "Moyen",
  "high": "Eleve",
  "critical": "Critique",
};

const Map<String, String> kExpenseCategoryLabels = {
  "materials": "Materiaux",
  "labor": "Main d'oeuvre",
  "transport": "Transport",
  "equipment": "Equipement",
  "subcontractor": "Sous-traitant",
  "administrative": "Administratif",
  "other": "Autre",
};

const Map<String, String> kAlertLevelLabels = {
  "info": "Info",
  "warning": "Attention",
  "critical": "Critique",
};
