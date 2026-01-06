from django.conf import settings
from django.db import models


class Medicine(models.Model):
    """
    A medicine the user needs to take, with daily reminder times.
    This mirrors the shape used in the frontend store.
    """

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="medicines",
        null=True,
        blank=True,
    )
    name = models.CharField(max_length=255)
    # List of times during the day, e.g. ["07:00", "12:00", "18:00"]
    times = models.JSONField(default=list)
    # Free-text dosage/posology description
    posology = models.CharField(max_length=255)
    # How many days the treatment lasts
    duration = models.PositiveIntegerField(help_text="Duration in days")

    # Additional fields used by the reminder logic
    start_date = models.DateField(auto_now_add=True)
    taken_times = models.JSONField(default=dict, blank=True)
    last_notified = models.JSONField(default=dict, blank=True)
    completed = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self) -> str:
        return self.name
