from django.urls import path

from .views import (
    ChangePasswordView,
    CustomTokenObtainPairView,
    MeView,
    OrganizationListView,
    UserListCreateView,
)

urlpatterns = [
    path("auth/login/", CustomTokenObtainPairView.as_view(), name="login"),
    path("auth/me/", MeView.as_view(), name="me"),
    path("auth/change-password/", ChangePasswordView.as_view(), name="change_password"),
    path("users/", UserListCreateView.as_view(), name="user_list"),
    path("organizations/", OrganizationListView.as_view(), name="organization_list"),
]
