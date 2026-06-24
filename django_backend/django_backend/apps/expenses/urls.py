from django.urls import path
from .views import ExpenseDetailView, ExpenseListCreateView

urlpatterns = [
    path("expenses/", ExpenseListCreateView.as_view(), name="expense_list"),
    path("expenses/<int:pk>/", ExpenseDetailView.as_view(), name="expense_detail"),
    path("projects/<int:project_pk>/expenses/", ExpenseListCreateView.as_view(), name="project_expense_list"),
]
