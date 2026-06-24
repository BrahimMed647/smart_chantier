from django.apps import AppConfig


class AccountsConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "apps.accounts"

    def ready(self):
        from django.db.models.signals import post_migrate
        post_migrate.connect(_seed_on_migrate, sender=self)


def _seed_on_migrate(sender, **kwargs):
    """Auto-seed demo data after every migrate if the DB is empty."""
    try:
        from apps.accounts.models import Organization
        if Organization.objects.exists():
            return
        from django.core.management import call_command
        call_command("seed_demo", verbosity=0)
    except Exception:
        pass
