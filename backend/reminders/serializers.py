from rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth import authenticate

from .models import Medicine


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)
    email = serializers.EmailField(required=False, allow_blank=True, allow_null=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'password', 'email']
        extra_kwargs = {'password': {'write_only': True}}

    def validate_email(self, value):
        # Convert empty string to None to avoid validation issues
        if value == '':
            return None
        return value

    def create(self, validated_data):
        email = validated_data.get('email')
        # Ensure email is not empty string
        if email == '':
            email = None
            
        user = User.objects.create_user(
            username=validated_data['username'],
            password=validated_data['password'],
            email=email or ''
        )
        return user


class MedicineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medicine
        fields = [
            "id",
            "user",
            "name",
            "times",
            "posology",
            "duration",
            "start_date",
            "taken_times",
            "last_notified",
            "completed",
            "created_at",
            "updated_at",
        ]
        read_only_fields = ["id", "user", "start_date", "created_at", "updated_at"]



