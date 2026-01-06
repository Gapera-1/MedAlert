# MedAlert - Medicine Reminder Web App

A React + Vite application for managing medicine reminders with a Django backend.

## Features

- Add medicines with multiple daily reminder times
- Track when medicines are taken
- Automatic reminders with browser notifications and voice alerts
- View contraindications for medicines
- Persistent storage via Django REST API backend

## Backend Integration

This frontend connects to a Django backend API. Make sure the backend is running before starting the frontend.

### Configuration

The API base URL can be configured via environment variable:

```bash
# Create a .env file in the frontend root
VITE_API_BASE_URL=http://localhost:8000/api
```

If not set, it defaults to `http://localhost:8000/api`.

## Development

### Install Dependencies

```bash
npm install
```

### Run Development Server

```bash
npm run dev
```

The app will be available at `http://localhost:5173` (or the port Vite assigns).

### Build for Production

```bash
npm run build
```

## Backend Setup

See the `../backend/README.md` for Django backend setup instructions.

## Tech Stack

- **React 19** - UI framework
- **Vite** - Build tool and dev server
- **Zustand** - State management
- **React Router** - Routing
- **Tailwind CSS** - Styling
- **Django REST Framework** - Backend API
