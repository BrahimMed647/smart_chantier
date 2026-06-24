"""
Management command: python manage.py seed_demo
Seeds demo data (organization, users, projects, tasks, reports, expenses, alerts).
"""
from datetime import date, timedelta

from django.core.management.base import BaseCommand
from django.utils import timezone

TODAY = date.today()


def days_ago(n):
    return TODAY - timedelta(days=n)


def days_from_now(n):
    return TODAY + timedelta(days=n)


class Command(BaseCommand):
    help = "Seed demo data for Smart Chantier"

    def handle(self, *args, **options):
        from apps.accounts.models import Organization, User
        from apps.projects.models import Project
        from apps.tasks.models import Task
        from apps.reports.models import DailyReport
        from apps.expenses.models import Expense
        from apps.alerts.models import Alert

        self.stdout.write("Creating organization...")
        org, _ = Organization.objects.get_or_create(
            name="Smart MS",
            defaults={"description": "Société de gestion de chantiers"},
        )

        self.stdout.write("Creating users...")
        users = {}
        user_data = [
            ("admin@smartms.com", "admin12345", "Ahmed Benali", "admin"),
            ("engineer@smartms.com", "engineer123", "Karim Djebbar", "engineer"),
            ("manager@smartms.com", "manager123", "Sofiane Hamidi", "site_manager"),
            ("accountant@smartms.com", "account123", "Nadia Kaci", "accountant"),
        ]
        for email, password, name, role in user_data:
            user, created = User.objects.get_or_create(
                email=email,
                defaults={"name": name, "role": role, "organization": org},
            )
            if created:
                user.set_password(password)
                user.save()
            users[role] = user

        self.stdout.write("Creating projects...")
        p1, _ = Project.objects.get_or_create(
            name="Résidence Jasmine",
            defaults={
                "description": "Construction d'un immeuble résidentiel R+5 comprenant 24 appartements.",
                "location": "Alger, Hydra",
                "latitude": 36.745,
                "longitude": 3.053,
                "start_date": days_ago(120),
                "expected_end_date": days_from_now(60),
                "initial_budget": 45000000,
                "progress": 75,
                "status": "in_progress",
                "organization": org,
                "created_by": users["admin"],
            },
        )
        p2, _ = Project.objects.get_or_create(
            name="Centre Commercial Atlas",
            defaults={
                "description": "Construction d'un centre commercial sur 3 niveaux avec parking souterrain.",
                "location": "Oran, Les Amandiers",
                "latitude": 35.697,
                "longitude": -0.634,
                "start_date": days_ago(60),
                "expected_end_date": days_from_now(180),
                "initial_budget": 120000000,
                "progress": 35,
                "status": "in_progress",
                "organization": org,
                "created_by": users["admin"],
            },
        )
        p3, _ = Project.objects.get_or_create(
            name="École Primaire El Fath",
            defaults={
                "description": "Construction d'une école primaire de 12 classes avec salle polyvalente et cour.",
                "location": "Constantine, Nouvelle Ville",
                "latitude": 36.365,
                "longitude": 6.614,
                "start_date": days_ago(30),
                "expected_end_date": days_from_now(240),
                "initial_budget": 28000000,
                "progress": 10,
                "status": "in_progress",
                "organization": org,
                "created_by": users["admin"],
            },
        )
        p4, _ = Project.objects.get_or_create(
            name="Villa Prestige Sidi Yahia",
            defaults={
                "description": "Construction d'une villa individuelle de standing R+1 avec piscine et jardin.",
                "location": "Alger, Sidi Yahia",
                "latitude": 36.762,
                "longitude": 3.048,
                "start_date": days_ago(200),
                "expected_end_date": days_from_now(15),
                "initial_budget": 18000000,
                "progress": 95,
                "status": "in_progress",
                "organization": org,
                "created_by": users["admin"],
            },
        )
        p5, _ = Project.objects.get_or_create(
            name="Route Nationale RN12 — Section Blida",
            defaults={
                "description": "Réhabilitation de 8 km de route nationale : couche de base, revêtement bitumineux, signalisation.",
                "location": "Blida, Oued El Alleug",
                "latitude": 36.566,
                "longitude": 2.836,
                "start_date": days_ago(90),
                "expected_end_date": days_from_now(90),
                "initial_budget": 75000000,
                "progress": 50,
                "status": "delayed",
                "organization": org,
                "created_by": users["admin"],
            },
        )

        self.stdout.write("Creating tasks...")
        task_data = [
            # Résidence Jasmine
            (p1, "Terrassement et fouilles", "done", "critical", days_ago(120), days_ago(100), 100, "done"),
            (p1, "Fondations et semelles", "done", "critical", days_ago(100), days_ago(75), 100, "done"),
            (p1, "Structure béton armé R4-R5", "in_progress", "critical", days_ago(20), days_from_now(10), 80, "in_progress"),
            (p1, "Maçonnerie et cloisons", "in_progress", "high", days_ago(15), days_from_now(20), 45, "in_progress"),
            (p1, "Plomberie et électricité", "todo", "medium", days_from_now(5), days_from_now(35), 0, "todo"),
            (p1, "Carrelage et finitions", "todo", "medium", days_from_now(30), days_from_now(55), 0, "todo"),
            # Centre Commercial Atlas
            (p2, "Études et permis", "done", "critical", days_ago(60), days_ago(45), 100, "done"),
            (p2, "Terrassement général", "delayed", "high", days_ago(35), days_ago(10), 90, "delayed"),
            (p2, "Fondations profondes", "in_progress", "critical", days_ago(10), days_from_now(20), 40, "in_progress"),
            (p2, "Gros œuvre RDC", "todo", "high", days_from_now(15), days_from_now(60), 0, "todo"),
            # École El Fath
            (p3, "Études de sol et topographie", "done", "critical", days_ago(30), days_ago(20), 100, "done"),
            (p3, "Terrassement et termes", "in_progress", "high", days_ago(15), days_from_now(5), 60, "in_progress"),
            (p3, "Fondations superficielles", "todo", "critical", days_from_now(3), days_from_now(25), 0, "todo"),
            # Villa Prestige
            (p4, "Gros œuvre terminé", "done", "critical", days_ago(200), days_ago(120), 100, "done"),
            (p4, "Finitions intérieures", "done", "high", days_ago(60), days_ago(20), 100, "done"),
            (p4, "Piscine et aménagements extérieurs", "in_progress", "medium", days_ago(20), days_from_now(10), 70, "in_progress"),
            (p4, "Livraison et réception", "todo", "high", days_from_now(10), days_from_now(15), 0, "todo"),
            # Route RN12
            (p5, "Fraisage ancienne chaussée", "done", "high", days_ago(90), days_ago(70), 100, "done"),
            (p5, "Couche de fondation GNB", "done", "high", days_ago(65), days_ago(40), 100, "done"),
            (p5, "Couche de base GNA", "delayed", "critical", days_ago(35), days_ago(5), 75, "delayed"),
            (p5, "Revêtement bitumineux", "todo", "critical", days_from_now(5), days_from_now(45), 0, "todo"),
            (p5, "Signalisation horizontale et verticale", "todo", "medium", days_from_now(40), days_from_now(85), 0, "todo"),
        ]
        for proj, title, prio, _, start, end, prog, stat in task_data:
            Task.objects.get_or_create(
                project=proj,
                title=title,
                defaults={
                    "priority": prio,
                    "start_date": start,
                    "end_date": end,
                    "progress": prog,
                    "status": stat,
                    "created_by": users["admin"],
                    "assigned_to": users.get("engineer"),
                },
            )

        self.stdout.write("Creating reports...")
        report_data = [
            # Résidence Jasmine — plusieurs jours
            (p1, days_ago(1), "Coulage béton R4 côté Nord, 3 colonnes terminées", 12,
             "25 sacs ciment, 2 tonnes ferraille", "Bétonnière, grue",
             "Retard livraison adjuvant 2h", "Commande de remplacement effectuée",
             "Ensoleillé, 28°C", "Avancement conforme au planning", 5),
            (p1, days_ago(3), "Coffrage dalles R4 côté Sud, pose armatures", 14,
             "Planches coffrages, fil de ligature", "Grue, échafaudage",
             "", "",
             "Nuageux, 24°C", "Bonne cadence de travail", 4),
            (p1, days_ago(7), "Coulage poteau R3 côté Est terminé", 10,
             "18 sacs ciment, 1,2 tonne ferraille", "Bétonnière",
             "Panne bétonnière 1h", "Réparation sur place",
             "Ensoleillé, 30°C", "Délai rattrapé en fin de journée", 3),
            (p1, days_ago(14), "Maçonnerie cloisons intérieures RDC terminées", 8,
             "500 briques creuses, 15 sacs mortier", "Truelle, niveau laser",
             "", "",
             "Ensoleillé, 27°C", "RAS", 3),
            # Centre Commercial Atlas
            (p2, days_ago(1), "Battage pieux P15 à P22, 8 pieux terminés", 8,
             "Béton prêt à l'emploi 40m³", "Foreuse Liebherr LB16, camion toupie",
             "Terrain rocheux en profondeur 18m", "Ajout couronnes diamantées",
             "Venteux, 18°C", "Révision planning 3 jours supplémentaires", 3),
            (p2, days_ago(4), "Battage pieux P8 à P14, contrôle géotechnique", 9,
             "Béton C25/30 35m³", "Foreuse, camion toupie",
             "", "",
             "Nuageux, 20°C", "Résultats géotechnique conformes", 4),
            (p2, days_ago(10), "Terrassement zone B — volume excavé 320 m³", 15,
             "Carburant engins", "Pelle hydraulique CAT 320, camions benne ×3",
             "Rencontre nappe phréatique à -4m", "Pompage mis en place",
             "Pluvieux, 15°C", "Pompage continu prévu 48h", 2),
            # École El Fath
            (p3, days_ago(2), "Terrassement zone A — décapage terrain végétal 500 m²", 6,
             "Carburant pelle", "Pelle Komatsu PC200, niveleuse",
             "", "",
             "Ensoleillé, 22°C", "Terrain homogène, bon avancement", 8),
            (p3, days_ago(5), "Piquetage et implantation bâtiment principal", 4,
             "Piquets, cordeau, plâtre", "Théodolite, niveau optique",
             "", "",
             "Ensoleillé, 20°C", "Implantation validée par géomètre", 2),
            # Villa Prestige
            (p4, days_ago(1), "Carrelage piscine — pose faïence fond et parois", 5,
             "80 m² faïence piscine, colle imperméable", "Carrelette, niveau",
             "Joint silicone à refaire zone angle", "Reprise prévue demain",
             "Ensoleillé, 32°C", "Quasi-finition piscine", 5),
            (p4, days_ago(6), "Peinture façade extérieure 2ème couche", 4,
             "40 L peinture façade blanc cassé", "Pistolet airless, échelle",
             "", "",
             "Ensoleillé, 29°C", "Aspect final très satisfaisant", 3),
            # Route RN12
            (p5, days_ago(1), "Compactage couche de base GNA, PR3+200 à PR4+100", 10,
             "GNA 0/31.5 — 450 tonnes", "Niveleuse Caterpillar 140M, compacteur Bomag",
             "Bris ressort compacteur", "Remplacement pièce en cours (livraison demain)",
             "Nuageux, 16°C", "Arrêt compactage 3h, reprise demain matin", 2),
            (p5, days_ago(3), "Reprofilage accotements PR2+500 à PR3+200", 8,
             "Tout-venant 120 tonnes", "Niveleuse, compacteur léger",
             "", "",
             "Ensoleillé, 21°C", "Profil en travers conforme", 4),
            (p5, days_ago(8), "Pose couche de base PR1+000 à PR2+500", 12,
             "GNA 0/31.5 — 750 tonnes", "Finisseur Vögele 1800-3, compacteur Bomag BW213",
             "Météo défavorable — arrêt 2h", "Reprise après séchage",
             "Pluvieux puis ensoleillé, 17°C", "Densité Proctor atteinte 98%", 6),
        ]
        for proj, rdate, work, workers, mats, equip, prob, sol, weather, remarks, prog in report_data:
            DailyReport.objects.get_or_create(
                project=proj,
                report_date=rdate,
                defaults={
                    "work_done": work,
                    "workers_count": workers,
                    "materials_used": mats,
                    "equipment_used": equip,
                    "problems": prob,
                    "solutions": sol,
                    "weather": weather,
                    "remarks": remarks,
                    "progress_today": prog,
                    "created_by": users["site_manager"],
                },
            )

        self.stdout.write("Creating expenses...")
        expense_data = [
            # Résidence Jasmine
            (p1, "Achat ciment Portland CEM II", 480000, "materials", days_ago(5)),
            (p1, "Salaires ouvriers — Semaine 48", 1250000, "labor", days_ago(3)),
            (p1, "Location grue à tour",            3200000, "equipment", days_ago(10)),
            (p1, "Ferraille HA 10/12/14",           2850000, "materials", days_ago(8)),
            (p1, "Briques creuses 20×20×40",         320000, "materials", days_ago(12)),
            (p1, "Honoraires bureau d'études",       750000, "other",     days_ago(30)),
            # Centre Commercial Atlas
            (p2, "Foreuse Liebherr LB16 — location", 8500000, "equipment", days_ago(30)),
            (p2, "Béton prêt à l'emploi C25/30",     3600000, "materials", days_ago(7)),
            (p2, "Main d'œuvre pieux",               5200000, "labor",     days_ago(14)),
            (p2, "Pompes de chantier ×2",             480000, "equipment", days_ago(9)),
            (p2, "Étude géotechnique complémentaire", 950000, "other",     days_ago(20)),
            # École El Fath
            (p3, "Location pelle Komatsu PC200",      650000, "equipment", days_ago(5)),
            (p3, "Carburant engins — semaine 1",       95000, "other",     days_ago(4)),
            (p3, "Piquets et matériel topographie",    28000, "materials", days_ago(6)),
            # Villa Prestige
            (p4, "Faïence piscine importée",          920000, "materials", days_ago(8)),
            (p4, "Peinture façade et intérieure",     380000, "materials", days_ago(7)),
            (p4, "Main d'œuvre finitions — mois 6",   850000, "labor",     days_ago(3)),
            (p4, "Mobilier et équipements cuisine",  1450000, "other",     days_ago(15)),
            # Route RN12
            (p5, "GNA 0/31.5 — livraison 1 500 T",  3750000, "materials", days_ago(12)),
            (p5, "Location finisseur Vögele 1800",   4200000, "equipment", days_ago(20)),
            (p5, "Location compacteur Bomag BW213",  2800000, "equipment", days_ago(20)),
            (p5, "Salaires équipe route — mois 2",   2100000, "labor",     days_ago(5)),
            (p5, "Signalisation temporaire chantier",  185000, "other",    days_ago(25)),
        ]
        for proj, title, amount, cat, exp_date in expense_data:
            Expense.objects.get_or_create(
                project=proj,
                title=title,
                defaults={
                    "amount": amount,
                    "category": cat,
                    "expense_date": exp_date,
                    "created_by": users["accountant"],
                },
            )

        self.stdout.write("Creating alerts...")
        alert_data = [
            # Résidence Jasmine
            (p1, "Tâche en retard", "task_delayed", "warning", "unread",
             "La tâche 'Structure béton armé R4-R5' risque de dépasser la date limite.",
             users["admin"]),
            (p1, "Effectif insuffisant", "workforce", "info", "unread",
             "Le nombre d'ouvriers prévu (15) est inférieur au besoin pour tenir le planning. Prévoir renforts.",
             users["site_manager"]),
            # Centre Commercial Atlas
            (p2, "Terrassement hors délai", "task_delayed", "critical", "unread",
             "Le terrassement général est à 90% mais la date prévue est dépassée de 10 jours.",
             users["admin"]),
            (p2, "Coût fondations en hausse", "budget", "warning", "unread",
             "Le terrain rocheux rallonge les travaux. Budget pieux à réviser +15% (≈ +1 275 000 DA).",
             users["accountant"]),
            (p2, "Nappe phréatique détectée", "safety", "critical", "unread",
             "Présence d'eau à -4m zone B. Pompage continu requis — risque d'affaissement terrain.",
             users["engineer"]),
            # École El Fath
            (p3, "Permis de construire expiré", "regulatory", "critical", "unread",
             "Le permis de construire arrive à échéance dans 15 jours. Renouvellement urgent à initier.",
             users["admin"]),
            (p3, "Livraison matériaux retardée", "supply", "warning", "unread",
             "Le fournisseur de ciment a signalé un délai supplémentaire de 7 jours. Impact sur planning fondations.",
             users["site_manager"]),
            # Villa Prestige
            (p4, "Livraison finale dans 15 jours", "milestone", "info", "read",
             "La réception provisoire est prévue dans 15 jours. Vérifier la liste des réserves.",
             users["admin"]),
            (p4, "Dépassement budget aménagements", "budget", "warning", "unread",
             "Le coût des aménagements extérieurs dépasse le budget initial de 8% (+ 1 440 000 DA).",
             users["accountant"]),
            # Route RN12
            (p5, "Retard couche de base", "task_delayed", "critical", "unread",
             "La couche de base GNA accuse 30 jours de retard en raison de pannes matériel et intempéries.",
             users["admin"]),
            (p5, "Panne compacteur Bomag", "equipment", "warning", "unread",
             "Bris de ressort sur compacteur Bomag BW213. Pièce commandée — arrêt prévu 2 jours.",
             users["engineer"]),
            (p5, "Budget matériaux dépassé de 12%", "budget", "warning", "unread",
             "La quantité de GNA consommée dépasse les prévisions. Révision budget matériaux requise.",
             users["accountant"]),
        ]
        for proj, title, atype, level, status, message, creator in alert_data:
            Alert.objects.get_or_create(
                project=proj,
                title=title,
                defaults={
                    "alert_type": atype,
                    "level": level,
                    "message": message,
                    "status": status,
                    "created_by": creator,
                },
            )

        self.stdout.write(self.style.SUCCESS("Demo data seeded successfully!"))
        self.stdout.write("  Projets  : 5")
        self.stdout.write("  Rapports : 13")
        self.stdout.write("  Alertes  : 12")
        self.stdout.write("  Login    : admin@smartms.com / admin12345")
