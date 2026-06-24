/// Change this to your Django backend URL.
/// For local development: http://10.0.2.2:8000 (Android emulator)
/// For device on same network: http://192.168.x.x:8000
/// For web (Edge/Chrome): http://localhost:8000
import "package:flutter/foundation.dart";

const String _androidUrl = "http://10.0.2.2:8000/api";
const String _webUrl = "http://localhost:8000/api";
final String kBaseUrl = kIsWeb ? _webUrl : _androidUrl;

/// Role labels in French
const Map<String, String> kRoleLabels = {
  "admin": "Administrateur",
  "user_admin": "Admin Utilisateurs",
  "engineer": "Ingénieur",
  "site_manager": "Chef de Chantier",
  "accountant": "Comptable",
  "client": "Client / Maître d'Ouvrage",
};

/// Project status labels
const Map<String, String> kProjectStatusLabels = {
  "planned": "Planifié",
  "in_progress": "En cours",
  "on_hold": "En pause",
  "delayed": "En retard",
  "completed": "Terminé",
  "cancelled": "Annulé",
};

/// Task status labels
const Map<String, String> kTaskStatusLabels = {
  "todo": "À faire",
  "in_progress": "En cours",
  "done": "Terminé",
  "delayed": "En retard",
  "cancelled": "Annulé",
};

/// Task priority labels
const Map<String, String> kTaskPriorityLabels = {
  "low": "Faible",
  "medium": "Moyen",
  "high": "Élevé",
  "critical": "Critique",
};

/// Expense category labels
const Map<String, String> kExpenseCategoryLabels = {
  "materials": "Matériaux",
  "labor": "Main d'œuvre",
  "transport": "Transport",
  "equipment": "Équipement",
  "subcontractor": "Sous-traitant",
  "administrative": "Administratif",
  "other": "Autre",
};

/// Alert level labels
const Map<String, String> kAlertLevelLabels = {
  "info": "Info",
  "warning": "Attention",
  "critical": "Critique",
};
