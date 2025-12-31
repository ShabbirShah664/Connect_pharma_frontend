// lib/core/api_constants.dart

// The base URL for your running Node.js API (e.g., http://localhost:3000/api)

// IMPORTANT NOTES:
// 1. Android Emulator: Use 10.0.2.2 to connect to your host machine's localhost.
// 2. iOS Simulator: Use http://localhost:3000/api
// 3. Physical Device: Replace '10.0.2.2' with your computer's local IP address
//    (e.g., http://192.168.1.XXX:3000/api).

class ApiConstants {
  // 1. Base URL - Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
  // Ensure there is NO trailing slash here to avoid // in your URLs
  static const String BASE_URL = 'http://localhost:3000/api';

  // 2. Authentication Endpoints
  static const String AUTH_LOGIN = '/auth/login';
  static const String AUTH_SIGNUP = '/auth/signup';

  // 3. User & Profile Endpoints
  static const String USER_PROFILE = '/profile';
  static const String RECORDS = '/records';

  // 4. Request & Search Endpoints
  static const String REQUEST_MEDICINE = '/requests';
  static const String REQUEST_USER = '/requests/user';
  static const String REQUEST_AVAILABLE = '/requests/available';
  static const String SEARCH = '/search'; // Used for the search route
  static const String CHAT = '/chat';

  // 5. Mapbox Configuration
  // REPLACE 'YOUR_MAPBOX_TOKEN' with your actual secret key from Mapbox
  static const String MAPBOX_ACCESS_TOKEN = 'YOUR_MAPBOX_TOKEN_HERE';
  static const String MAPBOX_STYLE = 'mapbox://styles/mapbox/streets-v11';
}