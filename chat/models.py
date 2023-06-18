from django.conf import settings
from django.db import models
from django.utils import timezone


class ChatMessage(models.Model):
    message = models.TextField()
    room_name = models.CharField(max_length=512)
    posted_by = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    posted_at = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return str(self.id)
