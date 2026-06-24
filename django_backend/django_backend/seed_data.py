import os, django, random
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from datetime import date, timedelta
from apps.accounts.models import User, Organization
from apps.projects.models import Project
from apps.tasks.models import Task
from apps.reports.models import DailyReport
from apps.expenses.models import Expense
from apps.alerts.models import Alert

admin = User.objects.get(email='admin@smartms.com')
org = admin.organization

# ── PROJETS ───────────────────────────────────────────────────────────────────
projects_data = [
    dict(
        name='Construction Immeuble R+5 Alger',
        description='Construction d un immeuble résidentiel de 5 étages avec sous-sol parking et 24 appartements.',
        location='Hydra, Alger',
        start_date=date(2025, 3, 1),
        expected_end_date=date(2026, 9, 30),
        initial_budget=85_000_000,
        progress=62,
        status='in_progress',
    ),
    dict(
        name='Route Nationale RN5 - Section Blida',
        description='Réhabilitation et élargissement de 12 km de route nationale entre Blida et Médéa.',
        location='Blida',
        start_date=date(2025, 6, 15),
        expected_end_date=date(2026, 12, 31),
        initial_budget=120_000_000,
        progress=35,
        status='in_progress',
    ),
    dict(
        name='Centre Commercial Oran West',
        description='Construction d un centre commercial de 8000 m² avec parking souterrain de 300 places.',
        location='Oran',
        start_date=date(2024, 10, 1),
        expected_end_date=date(2025, 12, 31),
        initial_budget=200_000_000,
        progress=100,
        status='completed',
    ),
    dict(
        name='Lycée Technique Constantine',
        description='Construction d un lycée technique de 1200 élèves avec ateliers spécialisés et laboratoires.',
        location='Constantine',
        start_date=date(2026, 2, 1),
        expected_end_date=date(2027, 8, 31),
        initial_budget=45_000_000,
        progress=18,
        status='in_progress',
    ),
    dict(
        name='Station Épuration Annaba',
        description='Réhabilitation de la station d épuration des eaux usées, capacité 50 000 m³/jour.',
        location='Annaba',
        start_date=date(2025, 9, 1),
        expected_end_date=date(2026, 3, 31),
        initial_budget=35_000_000,
        progress=45,
        status='delayed',
    ),
]

created = []
for pd in projects_data:
    p, new = Project.objects.get_or_create(
        name=pd['name'],
        defaults={**pd, 'organization': org, 'created_by': admin},
    )
    created.append(p)
print(f'Projets : {len(created)}')

p0, p1, p2, p3, p4 = created

# ── TÂCHES ────────────────────────────────────────────────────────────────────
tasks_data = [
    ('Terrassement et fouilles', 'done',        'high',     100, p0, date(2025,5,30)),
    ('Fondations béton armé',    'done',        'critical', 100, p0, date(2025,7,31)),
    ('Structure RDC et R+1',     'done',        'high',     100, p0, date(2025,11,30)),
    ('Structure R+2 et R+3',     'in_progress', 'high',      70, p0, date(2026,3,31)),
    ('Plomberie et électricité', 'todo',        'medium',     0, p0, date(2026,7,31)),
    ('Revêtement et façade',     'todo',        'medium',     0, p0, date(2026,8,31)),

    ('Décapage chaussée existante',   'done',        'high',  100, p1, date(2025,9,30)),
    ('Pose grave bitume couche base', 'in_progress', 'high',   60, p1, date(2026,6,30)),
    ('Enrobé couche de roulement',    'todo',        'high',    0, p1, date(2026,10,31)),
    ('Signalisation horizontale',     'todo',        'low',     0, p1, date(2026,12,1)),

    ('Fondations parking souterrain', 'done',        'critical', 100, p3, date(2026,4,30)),
    ('Gros oeuvre RDC',               'in_progress', 'high',      40, p3, date(2026,8,31)),
    ('Installation sanitaires',       'todo',        'medium',     0, p3, date(2027,2,28)),

    ('Diagnostic réseau existant', 'done',        'high',    100, p4, date(2025,10,31)),
    ('Remplacement pompes P1-P3',  'in_progress', 'critical',  50, p4, date(2026,2,28)),
    ('Tests et mise en service',   'todo',        'high',       0, p4, date(2026,3,31)),
]

for title, status, priority, progress, proj, end in tasks_data:
    Task.objects.get_or_create(
        title=title, project=proj,
        defaults=dict(
            description=f'Exécution: {title}',
            start_date=proj.start_date,
            end_date=end,
            progress=progress,
            priority=priority,
            status=status,
            assigned_to=admin,
            created_by=admin,
        ),
    )
print(f'Tâches : {len(tasks_data)}')

# ── DÉPENSES ──────────────────────────────────────────────────────────────────
expenses_data = [
    (p0, 'Achat ciment Portland 500T',       4_200_000, 'materials',      date(2025, 4,10)),
    (p0, 'Ferraillage acier HA',             6_800_000, 'materials',      date(2025, 5,20)),
    (p0, 'Main d oeuvre mois Mai 2025',      3_200_000, 'labor',          date(2025, 5,31)),
    (p0, 'Location grue 3 mois',             2_400_000, 'equipment',      date(2025, 6, 1)),
    (p0, 'Transport matériaux',                800_000, 'transport',      date(2025, 7,15)),
    (p0, 'Main d oeuvre mois Oct 2025',      3_400_000, 'labor',          date(2025,10,31)),
    (p0, 'Béton prêt à emploi 200m³',        3_600_000, 'materials',      date(2025,11,15)),

    (p1, 'Bitume 200T lot 1',                9_600_000, 'materials',      date(2025, 7, 5)),
    (p1, 'Location engins BTP',              5_200_000, 'equipment',      date(2025, 8, 1)),
    (p1, 'Main d oeuvre équipe route',       4_100_000, 'labor',          date(2025, 9,30)),
    (p1, 'Bitume 150T lot 2',                7_200_000, 'materials',      date(2026, 1,10)),
    (p1, 'Sous-traitant signalisation',      2_800_000, 'subcontractor',  date(2026, 3,20)),

    (p3, 'Béton prêt emploi 300m³',          5_100_000, 'materials',      date(2026, 3, 1)),
    (p3, 'Sous-traitant coffrage',           3_800_000, 'subcontractor',  date(2026, 3,15)),
    (p3, 'Acier pour fondations',            2_900_000, 'materials',      date(2026, 4,10)),

    (p4, 'Pompes industrielles x3',          8_500_000, 'equipment',      date(2025,10,20)),
    (p4, 'Tuyauteries PVC 500ml',            2_300_000, 'materials',      date(2025,11, 5)),
    (p4, 'Main d oeuvre spécialisée',        3_100_000, 'labor',          date(2025,12,31)),
]

for proj, title, amount, cat, edate in expenses_data:
    Expense.objects.get_or_create(
        title=title, project=proj,
        defaults=dict(amount=amount, category=cat, expense_date=edate, created_by=admin),
    )
print(f'Dépenses : {len(expenses_data)}')

# ── RAPPORTS JOURNALIERS ──────────────────────────────────────────────────────
reports_data = [
    (p0, date(2026,6,18), 'Coulage dalle R+2 terminé. Vibrage béton effectué.', 45, 'Béton B25, Coffrage bois', 'Grue 50T, Bétonnière', 'Aucun', 'Ensoleillé', 5),
    (p0, date(2026,6,17), 'Ferraillage poteaux R+2. Livraison acier 15T reçue.', 42, 'Acier HA16, Fil de ligature', 'Grue 50T', 'Aucun', 'Nuageux', 3),
    (p0, date(2026,6,16), 'Coffrage dalles niveau R+1 finalisé.', 38, 'Coffrage, Étais', 'Grue 50T', 'Aucun', 'Ensoleillé', 4),
    (p0, date(2026,6,13), 'Décoffrage R+1 effectué. Contrôle qualité béton OK.', 35, 'Néant', 'Marteau piqueur', 'Aucun', 'Ensoleillé', 2),

    (p1, date(2026,6,18), 'Pose grave bitume km 4 à km 6. Compactage densité 98%.', 55, 'Grave bitume 0/14', 'Finisseur, Rouleau compacteur', 'Aucun', 'Ensoleillé', 8),
    (p1, date(2026,6,17), 'Décapage section 3. Livraison bitume reportée au 19/06.', 50, 'Néant', 'Niveleuse, Chargeuse', 'Retard livraison bitume', 'Couvert', 5),
    (p1, date(2026,6,16), 'Mise en oeuvre grave non traitée km 2-4.', 52, 'GNT 0/31.5', 'Finisseur, Compacteur', 'Aucun', 'Ensoleillé', 6),

    (p3, date(2026,6,18), 'Coulage semelles isolées axes A et B. 18 semelles réalisées.', 22, 'Béton B25 armé', 'Bétonnière, Vibreur', 'Aucun', 'Ensoleillé', 4),
    (p3, date(2026,6,17), 'Ferraillage semelles axe C et D. Attente béton prêt à emploi.', 20, 'Acier HA12 HA16', 'Cisaille, Cintreuse', 'Aucun', 'Partiellement nuageux', 3),

    (p4, date(2026,6,17), 'Installation pompe P1 et P2 terminée. Test hydraulique 4 bars réussi.', 35, 'Tuyaux DN200, Joints', 'Grue mobile, Clés dynamométriques', 'Fuite mineure joint P2 corrigée', 'Ensoleillé', 6),
    (p4, date(2026,6,16), 'Câblage électrique armoire de commande. Mise en service partielle.', 30, 'Câbles électriques, Connecteurs', 'Multimètre, Outils électriques', 'Aucun', 'Ensoleillé', 5),
]

for proj, rdate, work, workers, mats, equip, problems, weather, prog in reports_data:
    DailyReport.objects.get_or_create(
        project=proj, report_date=rdate,
        defaults=dict(
            work_done=work,
            workers_count=workers,
            materials_used=mats,
            equipment_used=equip,
            problems=problems,
            solutions='Mesures correctives appliquées' if problems != 'Aucun' else 'RAS',
            weather=weather,
            remarks='Avancement conforme au planning',
            progress_today=prog,
            created_by=admin,
        ),
    )
print(f'Rapports : {len(reports_data)}')

# ── ALERTES ───────────────────────────────────────────────────────────────────
alerts_data = [
    (p1, 'critical', 'budget_overrun',
     'Dépassement budget imminent - RN5',
     'Le projet Route RN5 a consommé 78% du budget pour seulement 35% d avancement. Risque élevé de dépassement budgétaire.',
     'unread'),
    (p4, 'critical', 'delay',
     'Retard critique - Station Épuration',
     'La station d épuration accuse 45 jours de retard sur le planning initial. La date de livraison contractuelle est dépassée.',
     'unread'),
    (p0, 'warning', 'weather',
     'Conditions météo défavorables - Alger',
     'Prévisions de pluies importantes (60mm) pour la semaine du 22/06. Risque d arrêt de chantier 3 à 4 jours.',
     'unread'),
    (p3, 'warning', 'supply',
     'Stock ciment insuffisant - Constantine',
     'Niveau de stock ciment critique: 12 sacs restants. Besoin de 80 sacs pour la semaine prochaine. Commande urgente requise.',
     'unread'),
    (p1, 'warning', 'delay',
     'Retard livraison bitume',
     'La livraison de bitume prévue le 17/06 est reportée au 19/06. Impact sur planning section km 4-6.',
     'read'),
    (p0, 'info', 'milestone',
     'Milestone atteint - Immeuble Alger',
     'La structure R+1 est terminée conformément au planning. Avancement global 62%. Félicitations à l équipe chantier.',
     'read'),
    (p2, 'info', 'completion',
     'Projet livré avec succès - Oran West',
     'Le Centre Commercial Oran West a été livré dans les délais et dans le budget prévu (196M DA sur 200M DA).',
     'resolved'),
]

for proj, level, atype, title, msg, status in alerts_data:
    Alert.objects.get_or_create(
        title=title, project=proj,
        defaults=dict(level=level, alert_type=atype, message=msg, status=status, created_by=admin),
    )
print(f'Alertes : {len(alerts_data)}')
print('Données insérées avec succès !')
