from django.contrib import admin

from .models import Medicine


@admin.register(Medicine)
class MedicineAdmin(admin.ModelAdmin):
    list_display = ("id", "name", "user", "duration", "completed", "start_date")
    list_filter = ("completed", "start_date")
    search_fields = ("name", "user__username")

