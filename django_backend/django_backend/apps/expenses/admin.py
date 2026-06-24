from django.contrib import admin
from .models import Expense


@admin.register(Expense)
class ExpenseAdmin(admin.ModelAdmin):
    list_display = ["title", "project", "amount", "category", "expense_date"]
    list_filter = ["category", "project"]
    search_fields = ["title", "project__name"]
    ordering = ["-expense_date"]
