// lib/core/constants.dart

// Base URL for your backend API
// IMPORTANT: Replace 'http://your-backend-ip:3000' with your actual backend address.
// Use 'http://10.0.2.2:3000' for Android Emulators if running locally, or your actual IP address.
const String kBaseUrl = 'http://localhost:3000/api';

// Authentication endpoints
const String kLoginEndpoint = '/auth/login';
const String kRegisterEndpoint = '/auth/register';

// Profile endpoints
const String kProfileEndpoint = '/user/profile';

// Search endpoints
const String kSearchEndpoint = '/search/medicine';

// Google Maps API Key
// NOTE: This constant is required for Google Maps integration.
// You must obtain your key from the Google Cloud Console and replace the placeholder below.
const String kGoogleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';

// Key for Shared Preferences (for storing JWT token)
const String kAuthTokenKey = 'authToken';