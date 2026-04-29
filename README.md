# Weatherly – Smart Weather Forecast App

## Overview

Weatherly is a Flutter-based weather application that provides real-time weather updates, hourly forecasts, and a multi-day outlook. The app was designed with a focus on clean architecture, responsive UI, and practical handling of real-world scenarios such as network failures and invalid user input.

This project was built as part of the HNG Internship (Stage 3 – Mobile Track), with an emphasis on API integration, state management, and building a smooth and reliable user experience.

---

## Features

- Location-based weather detection using device services  
- City search functionality  
- Real-time weather information including:
  - Temperature  
  - Weather condition  
  - Humidity  
  - Wind speed  
  - Atmospheric pressure  
- Hourly forecast (short-term intervals)  
- 5-day weather forecast  
- Offline caching of the last successful weather data  
- Error handling for:
  - Network connectivity issues  
  - Invalid city input  
  - Location permission handling  
- Dynamic UI theming based on weather conditions  
- Smooth animations for improved user experience  

---

## API Integration

Weather data is fetched using the OpenWeatherMap API.

- OpenWeatherMap API  
  https://openweathermap.org/api  

---

## Architecture and Approach

The application follows a modular and scalable structure to keep the codebase maintainable and easy to extend.

- **State Management:** Provider  
- **Data Flow:**  
  UI → Provider → Service Layer → API → Model → UI  
- **Local Storage:** Hive (used for lightweight offline caching)  

### Project Structure

- `features/` – Feature-based modules (weather logic, providers, UI)  
- `core/` – Shared utilities, constants, and helpers  
- `data/` – Models and API service handling  
- `widgets/` – Reusable UI components  

This structure keeps responsibilities well separated and makes the app easier to maintain.

---

## Animations

The application includes subtle animations to improve the overall experience:

- Animated hero section (fade and slide transitions)  
- Forecast list item entrance animations  
- Temperature value transition animation  
- Skeleton loading shimmer effect  

---

## Error Handling

The app is designed to provide clear and user-friendly feedback in different scenarios:

- Invalid city searches return a helpful message  
- Network failures display a generic connection error  
- Cached weather data is used as a fallback when available  
- Retry mechanisms are available for failed operations  

Sensitive technical details such as API keys or raw error logs are not exposed to the user.

---

## Screenshots

- Home screen (default weather view)  
![Home Screen](assets/screenshots/home_screen.jpeg)

- Hourly forecast section  
![Hourly Forecast](assets/screenshots/hourly%20forecast.jpg)

- 5-day forecast section  
![5 Day Forecast](assets/screenshots/five_day_forecast.jpg)

- Error state (invalid city / no network)  
![Error State](assets/screenshots/invalid%20search.jpeg)

- Loading state (skeleton UI)  
![Loading State](assets/screenshots/shimmer%20animation.jpeg)

---

## Live Preview

Appetize:  
https://appetize.io/app/b_ghkel4rf35kmlx4se277xghl7m

---

## Repository

GitHub:  
https://github.com/sudo-melanin/hng-stage-3-weatherly-app

---

## How to Run

1. Clone the repository  
2. Run `flutter pub get`  
3. Add your OpenWeather API key in a `.env` file  
4. Run the app:

```bash
flutter run
```

---

## How to Run

```bash
flutter build apk --release
```

The generated APK can be found at:
build/app/outputs/flutter-apk/app-release.apk