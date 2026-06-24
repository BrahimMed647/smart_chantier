import "../models/alert.dart";
import "../models/daily_report.dart";
import "../models/expense.dart";
import "../models/project.dart";
import "../models/task.dart";

// ─────────────────────────────────────────────────────────────────────────────
// PROJETS PAR DÉFAUT
// ─────────────────────────────────────────────────────────────────────────────
const List<Project> kDefaultProjects = [
  Project(
    id: 1,
    name: "Construction Immeuble R+5 Alger",
    description: "Construction d'un immeuble résidentiel de 5 étages avec sous-sol parking et 24 appartements.",
    location: "Hydra, Alger",
    startDate: "2025-03-01",
    expectedEndDate: "2026-09-30",
    initialBudget: 85000000,
    progress: 62,
    status: "in_progress",
    organizationName: "Smart Chantier Corp",
    createdByName: "Administrateur",
    totalExpenses: 23800000,
    remainingBudget: 61200000,
    budgetPercentage: 28,
    createdAt: "2025-02-15T08:00:00Z",
    updatedAt: "2026-06-18T10:30:00Z",
  ),
  Project(
    id: 2,
    name: "Route Nationale RN5 – Section Blida",
    description: "Réhabilitation et élargissement de 12 km de route nationale entre Blida et Médéa.",
    location: "Blida",
    startDate: "2025-06-15",
    expectedEndDate: "2026-12-31",
    initialBudget: 120000000,
    progress: 35,
    status: "in_progress",
    organizationName: "Smart Chantier Corp",
    createdByName: "Administrateur",
    totalExpenses: 93600000,
    remainingBudget: 26400000,
    budgetPercentage: 78,
    createdAt: "2025-06-01T08:00:00Z",
    updatedAt: "2026-06-18T09:00:00Z",
  ),
  Project(
    id: 3,
    name: "Centre Commercial Oran West",
    description: "Construction d'un centre commercial de 8 000 m² avec parking souterrain 300 places.",
    location: "Oran",
    startDate: "2024-10-01",
    expectedEndDate: "2025-12-31",
    initialBudget: 200000000,
    progress: 100,
    status: "completed",
    organizationName: "Smart Chantier Corp",
    createdByName: "Administrateur",
    totalExpenses: 196000000,
    remainingBudget: 4000000,
    budgetPercentage: 98,
    createdAt: "2024-09-15T08:00:00Z",
    updatedAt: "2026-01-10T14:00:00Z",
  ),
  Project(
    id: 4,
    name: "Lycée Technique Constantine",
    description: "Construction d'un lycée technique 1 200 élèves avec ateliers spécialisés et laboratoires.",
    location: "Constantine",
    startDate: "2026-02-01",
    expectedEndDate: "2027-08-31",
    initialBudget: 45000000,
    progress: 18,
    status: "in_progress",
    organizationName: "Smart Chantier Corp",
    createdByName: "Administrateur",
    totalExpenses: 11800000,
    remainingBudget: 33200000,
    budgetPercentage: 26,
    createdAt: "2026-01-20T08:00:00Z",
    updatedAt: "2026-06-18T08:00:00Z",
  ),
  Project(
    id: 5,
    name: "Station Épuration Annaba",
    description: "Réhabilitation de la station d'épuration des eaux usées, capacité 50 000 m³/jour.",
    location: "Annaba",
    startDate: "2025-09-01",
    expectedEndDate: "2026-03-31",
    initialBudget: 35000000,
    progress: 45,
    status: "delayed",
    organizationName: "Smart Chantier Corp",
    createdByName: "Administrateur",
    totalExpenses: 13900000,
    remainingBudget: 21100000,
    budgetPercentage: 40,
    createdAt: "2025-08-20T08:00:00Z",
    updatedAt: "2026-06-17T16:00:00Z",
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// TÂCHES PAR DÉFAUT
// ─────────────────────────────────────────────────────────────────────────────
const List<Task> kDefaultTasks = [
  Task(id:1,  project:1, title:"Fondations béton armé",       description:"", startDate:"2025-03-01", endDate:"2025-07-31", progress:100, priority:"critical", status:"done",        assignedToName:"Administrateur", isOverdue:false, createdAt:"2025-03-01T08:00:00Z"),
  Task(id:2,  project:1, title:"Structure R+2 et R+3",        description:"", startDate:"2025-08-01", endDate:"2026-03-31", progress:70,  priority:"high",     status:"in_progress", assignedToName:"Administrateur", isOverdue:false, createdAt:"2025-08-01T08:00:00Z"),
  Task(id:3,  project:1, title:"Plomberie et électricité",    description:"", startDate:"2026-04-01", endDate:"2026-07-31", progress:0,   priority:"medium",   status:"todo",        assignedToName:"Administrateur", isOverdue:false, createdAt:"2026-01-01T08:00:00Z"),
  Task(id:4,  project:1, title:"Revêtement façade",           description:"", startDate:"2026-06-01", endDate:"2026-08-31", progress:0,   priority:"medium",   status:"todo",        assignedToName:"Administrateur", isOverdue:false, createdAt:"2026-01-01T08:00:00Z"),
  Task(id:5,  project:2, title:"Décapage chaussée existante", description:"", startDate:"2025-06-15", endDate:"2025-09-30", progress:100, priority:"high",     status:"done",        assignedToName:"Administrateur", isOverdue:false, createdAt:"2025-06-15T08:00:00Z"),
  Task(id:6,  project:2, title:"Pose grave bitume couche base",description:"", startDate:"2025-10-01", endDate:"2026-06-30", progress:60, priority:"high",     status:"in_progress", assignedToName:"Administrateur", isOverdue:false, createdAt:"2025-10-01T08:00:00Z"),
  Task(id:7,  project:2, title:"Signalisation horizontale",   description:"", startDate:"2026-10-01", endDate:"2026-12-01", progress:0,   priority:"low",      status:"todo",        assignedToName:"Administrateur", isOverdue:false, createdAt:"2026-01-01T08:00:00Z"),
  Task(id:8,  project:4, title:"Fondations parking souterrain",description:"",startDate:"2026-02-01", endDate:"2026-04-30", progress:100, priority:"critical", status:"done",        assignedToName:"Administrateur", isOverdue:false, createdAt:"2026-02-01T08:00:00Z"),
  Task(id:9,  project:4, title:"Gros œuvre RDC",             description:"", startDate:"2026-05-01", endDate:"2026-08-31", progress:40,  priority:"high",     status:"in_progress", assignedToName:"Administrateur", isOverdue:false, createdAt:"2026-05-01T08:00:00Z"),
  Task(id:10, project:5, title:"Remplacement pompes P1-P3",   description:"", startDate:"2025-11-01", endDate:"2026-02-28", progress:50,  priority:"critical", status:"in_progress", assignedToName:"Administrateur", isOverdue:true,  createdAt:"2025-11-01T08:00:00Z"),
  Task(id:11, project:5, title:"Tests et mise en service",    description:"", startDate:"2026-03-01", endDate:"2026-03-31", progress:0,   priority:"high",     status:"delayed",     assignedToName:"Administrateur", isOverdue:true,  createdAt:"2025-11-01T08:00:00Z"),
];

// ─────────────────────────────────────────────────────────────────────────────
// RAPPORTS PAR DÉFAUT
// ─────────────────────────────────────────────────────────────────────────────
const List<DailyReport> kDefaultReports = [
  DailyReport(
    id:1, project:1, projectName:"Construction Immeuble R+5 Alger",
    reportDate:"2026-06-18", workDone:"Coulage dalle R+2 terminé. Vibrage béton effectué sur toute la surface.",
    workersCount:45, materialsUsed:"Béton B25, Coffrage bois, Acier HA", equipmentUsed:"Grue 50T, Bétonnière 500L",
    problems:"Aucun", solutions:"RAS", weather:"Ensoleillé", remarks:"Avancement conforme au planning", progressToday:5, createdByName:"Administrateur", createdAt:"2026-06-18T17:00:00Z",
  ),
  DailyReport(
    id:2, project:1, projectName:"Construction Immeuble R+5 Alger",
    reportDate:"2026-06-17", workDone:"Ferraillage poteaux R+2. Livraison acier 15T reçue et stockée.",
    workersCount:42, materialsUsed:"Acier HA16, Fil de ligature", equipmentUsed:"Grue 50T, Cisaille",
    problems:"Aucun", solutions:"RAS", weather:"Nuageux", remarks:"Livraison conforme au BL", progressToday:3, createdByName:"Administrateur", createdAt:"2026-06-17T17:00:00Z",
  ),
  DailyReport(
    id:3, project:2, projectName:"Route Nationale RN5 – Section Blida",
    reportDate:"2026-06-18", workDone:"Pose grave bitume km 4 à km 6. Compactage densité 98% atteinte.",
    workersCount:55, materialsUsed:"Grave bitume 0/14, Émulsion", equipmentUsed:"Finisseur VOGELE, Rouleau compacteur",
    problems:"Aucun", solutions:"RAS", weather:"Ensoleillé", remarks:"Section km4-6 finalisée", progressToday:8, createdByName:"Administrateur", createdAt:"2026-06-18T17:30:00Z",
  ),
  DailyReport(
    id:4, project:2, projectName:"Route Nationale RN5 – Section Blida",
    reportDate:"2026-06-17", workDone:"Décapage section 3 terminé. Livraison bitume reportée au 19/06.",
    workersCount:50, materialsUsed:"Néant", equipmentUsed:"Niveleuse, Chargeuse CAT",
    problems:"Retard livraison bitume fournisseur", solutions:"Contact fournisseur, livraison confirmée 19/06", weather:"Couvert", remarks:"Attente matière première", progressToday:5, createdByName:"Administrateur", createdAt:"2026-06-17T17:00:00Z",
  ),
  DailyReport(
    id:5, project:4, projectName:"Lycée Technique Constantine",
    reportDate:"2026-06-18", workDone:"Coulage semelles isolées axes A et B. 18 semelles réalisées sur 24 prévues.",
    workersCount:22, materialsUsed:"Béton B25 armé, Acier HA12", equipmentUsed:"Bétonnière, Vibreur à béton",
    problems:"Aucun", solutions:"RAS", weather:"Ensoleillé", remarks:"Avancement satisfaisant", progressToday:4, createdByName:"Administrateur", createdAt:"2026-06-18T16:00:00Z",
  ),
  DailyReport(
    id:6, project:5, projectName:"Station Épuration Annaba",
    reportDate:"2026-06-17", workDone:"Installation pompe P1 et P2 terminée. Test hydraulique 4 bars réussi.",
    workersCount:35, materialsUsed:"Tuyaux DN200, Joints EPDM, Boulonnerie", equipmentUsed:"Grue mobile 20T, Clés dynamométriques",
    problems:"Fuite mineure joint pompe P2 détectée et corrigée sur place", solutions:"Remplacement joint EPDM DN200", weather:"Ensoleillé", remarks:"Pompes P1 et P2 opérationnelles", progressToday:6, createdByName:"Administrateur", createdAt:"2026-06-17T18:00:00Z",
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// ALERTES PAR DÉFAUT
// ─────────────────────────────────────────────────────────────────────────────
const List<Alert> kDefaultAlerts = [
  Alert(
    id:1, project:2, projectName:"Route Nationale RN5 – Section Blida",
    alertType:"budget_overrun", level:"critical",
    title:"Dépassement budget imminent – RN5",
    message:"Le projet Route RN5 a consommé 78% du budget pour seulement 35% d'avancement. Risque élevé de dépassement budgétaire. Une révision du budget ou un audit est nécessaire en urgence.",
    status:"unread", createdByName:"Système", createdAt:"2026-06-18T08:00:00Z",
  ),
  Alert(
    id:2, project:5, projectName:"Station Épuration Annaba",
    alertType:"delay", level:"critical",
    title:"Retard critique – Station Épuration Annaba",
    message:"La station d'épuration accuse 45 jours de retard sur le planning initial. La date de livraison contractuelle du 31/03/2026 est dépassée. Actions correctives requises immédiatement.",
    status:"unread", createdByName:"Système", createdAt:"2026-06-17T09:00:00Z",
  ),
  Alert(
    id:3, project:1, projectName:"Construction Immeuble R+5 Alger",
    alertType:"weather", level:"warning",
    title:"Conditions météo défavorables – Alger",
    message:"Prévisions de pluies importantes (60 mm) pour la semaine du 22/06. Risque d'arrêt de chantier 3 à 4 jours. Protéger les ouvrages en cours et sécuriser le matériel.",
    status:"unread", createdByName:"Système", createdAt:"2026-06-18T07:00:00Z",
  ),
  Alert(
    id:4, project:4, projectName:"Lycée Technique Constantine",
    alertType:"supply", level:"warning",
    title:"Stock ciment insuffisant – Constantine",
    message:"Niveau de stock ciment critique : 12 sacs restants. Besoin de 80 sacs pour la semaine prochaine. Passer la commande avant le 20/06 pour éviter un arrêt de chantier.",
    status:"unread", createdByName:"Système", createdAt:"2026-06-18T10:00:00Z",
  ),
  Alert(
    id:5, project:2, projectName:"Route Nationale RN5 – Section Blida",
    alertType:"delay", level:"warning",
    title:"Retard livraison bitume",
    message:"La livraison de bitume prévue le 17/06 est reportée au 19/06 par le fournisseur. Impact sur le planning de la section km 4-6. Prévoir décalage de 2 jours.",
    status:"read", createdByName:"Système", createdAt:"2026-06-17T14:00:00Z",
  ),
  Alert(
    id:6, project:1, projectName:"Construction Immeuble R+5 Alger",
    alertType:"milestone", level:"info",
    title:"Milestone atteint – Immeuble Alger",
    message:"La structure R+1 est terminée conformément au planning. Avancement global : 62%. Félicitations à l'équipe chantier pour le respect des délais.",
    status:"read", createdByName:"Système", createdAt:"2026-06-15T16:00:00Z",
  ),
  Alert(
    id:7, project:3, projectName:"Centre Commercial Oran West",
    alertType:"completion", level:"info",
    title:"Projet livré avec succès – Oran West",
    message:"Le Centre Commercial Oran West a été livré dans les délais et dans le budget prévu (196 M DA sur 200 M DA). Clôture administrative en cours.",
    status:"resolved", createdByName:"Système", createdAt:"2026-01-10T12:00:00Z",
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// DÉPENSES PAR DÉFAUT
// ─────────────────────────────────────────────────────────────────────────────
const List<Expense> kDefaultExpenses = [
  Expense(id:1,  project:1, projectName:"Construction Immeuble R+5 Alger",   title:"Achat ciment Portland 500T",    description:"", amount:4200000,  category:"materials",     expenseDate:"2025-04-10", createdByName:"Administrateur", createdAt:"2025-04-10T10:00:00Z"),
  Expense(id:2,  project:1, projectName:"Construction Immeuble R+5 Alger",   title:"Ferraillage acier HA",           description:"", amount:6800000,  category:"materials",     expenseDate:"2025-05-20", createdByName:"Administrateur", createdAt:"2025-05-20T10:00:00Z"),
  Expense(id:3,  project:1, projectName:"Construction Immeuble R+5 Alger",   title:"Main d'œuvre mois Mai 2025",    description:"", amount:3200000,  category:"labor",         expenseDate:"2025-05-31", createdByName:"Administrateur", createdAt:"2025-05-31T10:00:00Z"),
  Expense(id:4,  project:1, projectName:"Construction Immeuble R+5 Alger",   title:"Location grue 3 mois",          description:"", amount:2400000,  category:"equipment",     expenseDate:"2025-06-01", createdByName:"Administrateur", createdAt:"2025-06-01T10:00:00Z"),
  Expense(id:5,  project:1, projectName:"Construction Immeuble R+5 Alger",   title:"Béton prêt à emploi 200 m³",   description:"", amount:3600000,  category:"materials",     expenseDate:"2025-11-15", createdByName:"Administrateur", createdAt:"2025-11-15T10:00:00Z"),
  Expense(id:6,  project:2, projectName:"Route Nationale RN5 – Section Blida",title:"Bitume 200T lot 1",            description:"", amount:9600000,  category:"materials",     expenseDate:"2025-07-05", createdByName:"Administrateur", createdAt:"2025-07-05T10:00:00Z"),
  Expense(id:7,  project:2, projectName:"Route Nationale RN5 – Section Blida",title:"Location engins BTP",          description:"", amount:5200000,  category:"equipment",     expenseDate:"2025-08-01", createdByName:"Administrateur", createdAt:"2025-08-01T10:00:00Z"),
  Expense(id:8,  project:2, projectName:"Route Nationale RN5 – Section Blida",title:"Main d'œuvre équipe route",    description:"", amount:4100000,  category:"labor",         expenseDate:"2025-09-30", createdByName:"Administrateur", createdAt:"2025-09-30T10:00:00Z"),
  Expense(id:9,  project:2, projectName:"Route Nationale RN5 – Section Blida",title:"Bitume 150T lot 2",            description:"", amount:7200000,  category:"materials",     expenseDate:"2026-01-10", createdByName:"Administrateur", createdAt:"2026-01-10T10:00:00Z"),
  Expense(id:10, project:4, projectName:"Lycée Technique Constantine",         title:"Béton prêt emploi 300 m³",    description:"", amount:5100000,  category:"materials",     expenseDate:"2026-03-01", createdByName:"Administrateur", createdAt:"2026-03-01T10:00:00Z"),
  Expense(id:11, project:4, projectName:"Lycée Technique Constantine",         title:"Sous-traitant coffrage",       description:"", amount:3800000,  category:"subcontractor", expenseDate:"2026-03-15", createdByName:"Administrateur", createdAt:"2026-03-15T10:00:00Z"),
  Expense(id:12, project:5, projectName:"Station Épuration Annaba",            title:"Pompes industrielles x3",      description:"", amount:8500000,  category:"equipment",     expenseDate:"2025-10-20", createdByName:"Administrateur", createdAt:"2025-10-20T10:00:00Z"),
  Expense(id:13, project:5, projectName:"Station Épuration Annaba",            title:"Tuyauteries PVC 500 ml",       description:"", amount:2300000,  category:"materials",     expenseDate:"2025-11-05", createdByName:"Administrateur", createdAt:"2025-11-05T10:00:00Z"),
];

// ─────────────────────────────────────────────────────────────────────────────
// DASHBOARD PAR DÉFAUT
// ─────────────────────────────────────────────────────────────────────────────
const Map<String, dynamic> kDefaultDashboard = {
  "projects": {"total": 5, "in_progress": 3, "delayed": 1, "completed": 1, "planned": 0},
  "tasks":    {"total": 11, "done": 3, "in_progress": 4, "delayed": 2},
  "unread_alerts": 4,
  "budget": {
    "total": 485000000,
    "total_expenses": 143500000,
    "remaining": 341500000,
  },
};
