# Clear Sky App

A comprehensive Flutter application designed for astronomers and astrophotographers to plan their observation and photography sessions. This app combines weather forecasting with astronomical data to provide optimal viewing conditions and celestial object information.

## Features

### Weather Information
- Real-time local weather forecasts
- 48-hour cloud cover prediction graph
- Detailed weather metrics including:
  - Temperature
  - Humidity
  - Wind speed and direction
  - Visibility conditions
  - Precipitation probability

### Astronomical Data
- Moon phase tracking and visualization
- Sunrise and sunset times
- Moonrise and moonset times
- Astronomical twilight times
- Celestial object tracking:
  - Rise and set times for bright stars
  - Deep sky object visibility periods
  - Planet positions and visibility windows
  - New comet information and tracking

### Location Services
- Automatic location detection
- Custom location settings
- Coordinates for precise astronomical calculations

### Technical Features
- Offline database for celestial objects
- RA/Dec to Alt/Az coordinate conversion
- Time series visualization for weather patterns
- Local data storage for preferences
- Real-time updates

## Technical Details

- Built with Flutter SDK >=2.12.0
- Uses various Flutter packages for functionality:
  - `location` for GPS services
  - `http` for API communications
  - `charts_flutter` for data visualization
  - `shared_preferences` for local storage
  - `csv` for database management
  - Custom icon pack for weather and astronomical symbols

## Requirements

- Flutter (latest stable version)
- Android SDK for Android development
- Xcode for iOS development
- Internet connection for weather data
- Location permissions for device

## Setup

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Ensure you have required API keys for weather services
4. Run `flutter run` to start the app in debug mode

## Building for Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Data Sources

- Weather data from weather API services
- Astronomical calculations using standard astronomical algorithms
- Star database containing brightest visible stars
- NGC (New General Catalogue) for deep sky objects
- Planet ephemeris data for solar system objects
