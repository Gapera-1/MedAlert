## MedAlert Backend (Django + MySQL)

This is the backend API for the MedAlert medicine reminder app, built with **Django 6**, **Django REST Framework**, and **MySQL**.

### 1. System requirements

- Python 3.10+ (you have Python 3.12)
- MySQL server (5.7+ or MariaDB with JSON support)
- MySQL client development headers (for `mysqlclient`)

On Debian/Ubuntu you typically need:

```bash
sudo apt update
sudo apt install pkg-config default-libmysqlclient-dev python3-dev
```

### 2. Create and activate virtual environment

```bash
cd /home/francois/Desktop/MedAlert/backend
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
```

### 3. Install Python dependencies

```bash
pip install -r requirements.txt
```

Or install manually:
```bash
pip install django djangorestframework mysqlclient django-cors-headers
```

If `mysqlclient` fails to install, make sure the packages from step 1 are installed, then retry.

### 4. Configure the MySQL database

Create a database and user in MySQL, for example:

```sql
CREATE DATABASE medalert_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'medalert_user'@'localhost' IDENTIFIED BY 'change-me';
GRANT ALL PRIVILEGES ON medalert_db.* TO 'medalert_user'@'localhost';
FLUSH PRIVILEGES;
```

Then export matching environment variables (or adjust `DATABASES` in `settings.py`):

```bash
export MEDALERT_DB_NAME=medalert_db
export MEDALERT_DB_USER=medalert_user
export MEDALERT_DB_PASSWORD='change-me'
export MEDALERT_DB_HOST=127.0.0.1
export MEDALERT_DB_PORT=3306
```

### 5. Apply migrations and create a superuser

```bash
cd /home/francois/Desktop/MedAlert/backend
source .venv/bin/activate
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
```

### 6. Run the development server

```bash
python manage.py runserver 8000
```

The API will be available at `http://127.0.0.1:8000/api/`.

### 7. API endpoints

Main resources:

- `GET /api/medicines/` – list medicines
- `POST /api/medicines/` – create a medicine
- `GET /api/medicines/{id}/` – retrieve a medicine
- `PUT/PATCH /api/medicines/{id}/` – update a medicine
- `DELETE /api/medicines/{id}/` – delete a medicine
- `POST /api/medicines/{id}/mark_taken/` – body: `{"time": "07:00"}` – mark a specific dose time as taken
- `POST /api/medicines/{id}/mark_completed/` – mark treatment as completed

The fields on `Medicine` are designed to align with the current frontend store: `name`, `times` (list of `"HH:MM"` strings), `posology`, `duration` (days), `start_date`, `taken_times`, `last_notified`, `completed`.


