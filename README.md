# 🌍 EcoTrack

EcoTrack is a modern, intuitive carbon footprint tracker designed to help individuals understand, track, and reduce their environmental impact. Built with a focus on actionable insights, it offers low-friction activity logging and personalized, data-driven recommendations.

## ✨ Features
*   **Intuitive Dashboard:** Visualize your carbon footprint with beautiful charts broken down by category (Transport, Food, Energy, Waste).
*   **Frictionless Access:** Judges and users can instantly explore the app via the "Try as Guest" feature, providing an isolated sandbox experience without needing to create an account.
*   **Activity Logging:** Easily log daily activities like meals, transportation, and energy usage.
*   **Smart Recommendation Engine:** Get deterministic, rule-based insights and actionable tips based on your logged activities and lifestyle baseline.
*   **Gamification (Eco Points):** Earn Eco Points for logging activities and hitting eco-friendly milestones to stay motivated!
*   **Goal Tracking:** Set specific carbon reduction goals and track your progress over time.

## 🚀 Live Demo

*   **Frontend Web App:** [https://virtualwar-ecotrack-app.web.app](https://virtualwar-ecotrack-app.web.app)
*   **Backend API:** [https://ecotrack-backend-w70c.onrender.com](https://ecotrack-backend-w70c.onrender.com)

---

## 🏗️ Tech Stack (Monorepo)

This repository is organized as a monorepo containing both the frontend and backend applications.

### Backend (`/backend`)
*   **Framework:** FastAPI (Python 3.14+)
*   **Database:** SQLite + SQLModel (ORMs)
*   **Authentication:** JWT Bearer Tokens with Bcrypt hashing
*   **Deployment:** Render (Zero-config via `render.yaml`)
*   **Key Logic:** Deterministic recommendation engine in `recommendation_engine.py`

### Frontend (`/frontend/ecotrack_app`)
*   **Framework:** Flutter Web
*   **State Management:** Provider
*   **Styling:** Custom highly polished UI using Material 3 and Google Fonts
*   **Deployment:** Firebase Hosting
*   **API Connection:** `ApiService` wrapper handling JWT injection and HTTP requests

---

## 💻 Local Development

### Prerequisites
*   Python 3.10+
*   Flutter SDK (3.x)

### Running the Backend

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Start the FastAPI development server:
   ```bash
   uvicorn app.main:app --reload --port 8001
   ```
   *The API documentation will be available at `http://127.0.0.1:8001/docs`.*

### Running the Frontend

1. Navigate to the frontend directory:
   ```bash
   cd frontend/ecotrack_app
   ```
2. Install Flutter packages:
   ```bash
   flutter pub get
   ```
3. Run the app locally on Chrome:
   ```bash
   flutter run -d chrome
   ```
*(Note: If running locally, ensure `ApiService.baseUrl` in `lib/services/api_service.dart` is set to your local backend URL: `http://127.0.0.1:8001` instead of the Render URL).*

## 🚢 Deployment Workflow

### Backend (Render)
The backend is automatically deployed to Render via GitHub integration. The `render.yaml` file at the root of the repository defines the deployment configuration (`rootDir: backend`). Any pushes to the `main` branch will automatically trigger a new deployment.

### Frontend (Firebase)
To deploy a new version of the frontend web app to Firebase Hosting:
1. Navigate to the frontend folder: `cd frontend/ecotrack_app`
2. Build the highly-optimized production web bundle:
   ```bash
   flutter build web --release
   ```
3. Deploy to Firebase:
   ```bash
   firebase deploy
   ```
