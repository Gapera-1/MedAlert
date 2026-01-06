from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action, api_view, permission_classes
from rest_framework.response import Response
from django.contrib.auth.models import User
from django.contrib.auth import authenticate

from .models import Medicine
from .serializers import MedicineSerializer, UserSerializer


class MedicineViewSet(viewsets.ModelViewSet):
    """
    CRUD API for medicines and a couple of helper actions
    to mark doses as taken / completed.
    """

    serializer_class = MedicineSerializer
    permission_classes = [permissions.AllowAny]

    def get_queryset(self):
        # If you later add authentication, you can filter by user here:
        # return Medicine.objects.filter(user=self.request.user)
        return Medicine.objects.all()

    def perform_create(self, serializer):
        user = getattr(self.request, "user", None)
        if user and user.is_authenticated:
            serializer.save(user=user)
        else:
            serializer.save()

    @action(detail=True, methods=["post"])
    def mark_taken(self, request, pk=None):
        """
        Mark a specific time as taken for this medicine.
        Expects JSON body: {"time": "07:00"}
        """
        medicine = self.get_object()
        time = request.data.get("time")
        if not time:
            return Response({"detail": "Missing 'time'."}, status=400)

        taken_times = medicine.taken_times or {}
        taken_times[time] = True
        medicine.taken_times = taken_times
        medicine.save(update_fields=["taken_times"])
        return Response(MedicineSerializer(medicine).data)

    @action(detail=True, methods=["post"])
    def mark_completed(self, request, pk=None):
        """
        Mark this medicine's treatment as completed.
        """
        medicine = self.get_object()
        medicine.completed = True
        medicine.save(update_fields=["completed"])
        return Response(MedicineSerializer(medicine).data)


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def signup(request):
    """
    Register a new user.
    Expects: {"username": "user", "password": "pass", "email": "email@example.com"}
    """
    # Clean up email if it's an empty string
    data = request.data.copy()
    if 'email' in data and data['email'] == '':
        data['email'] = None
    
    serializer = UserSerializer(data=data)
    if serializer.is_valid():
        user = serializer.save()
        return Response({
            "message": "User created successfully",
            "user": {
                "id": user.id,
                "username": user.username,
                "email": user.email
            }
        }, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def login(request):
    """
    Authenticate a user and return user info.
    Expects: {"username": "user", "password": "pass", "email": "email@example.com"}
    Can login with either username or email.
    """
    username = request.data.get('username', '').strip() if request.data.get('username') else ''
    email = request.data.get('email', '').strip() if request.data.get('email') else ''
    password = request.data.get('password')
    
    if not password:
        return Response(
            {"detail": "Password is required"},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    # If email is provided, find user by email first
    if email:
        try:
            from django.contrib.auth.models import User
            user_by_email = User.objects.get(email=email)
            username = user_by_email.username
        except User.DoesNotExist:
            return Response(
                {"detail": "Invalid email or password"},
                status=status.HTTP_401_UNAUTHORIZED
            )
        except User.MultipleObjectsReturned:
            # Handle case where multiple users have the same email (shouldn't happen but handle it)
            return Response(
                {"detail": "Multiple accounts found with this email. Please contact support."},
                status=status.HTTP_400_BAD_REQUEST
            )
    elif not username:
        return Response(
            {"detail": "Username or email is required"},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    user = authenticate(username=username, password=password)
    
    if user is not None:
        return Response({
            "message": "Login successful",
            "user": {
                "id": user.id,
                "username": user.username,
                "email": user.email
            }
        }, status=status.HTTP_200_OK)
    else:
        return Response(
            {"detail": "Invalid username/email or password"},
            status=status.HTTP_401_UNAUTHORIZED
        )

