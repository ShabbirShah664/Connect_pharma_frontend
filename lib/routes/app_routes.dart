// lib/routes/app_routes.dart

import 'package:flutter/material.dart';
// Import all necessary view files
import '../features/auth/views/intro_page.dart';
import '../features/auth/views/user_login_page.dart';
import '../features/auth/views/pharmacist_login_page.dart'; // FIX 1: ADD THIS IMPORT
import '../features/auth/views/user_signup_page.dart';
import '../features/auth/views/role_select_page.dart'; 
import '../features/home/views/user_home_page.dart';
import '../features/home/views/user_profile_page.dart';
import '../features/home/views/searching_screen.dart';
import 'package:flutter_application_1/features/home/views/search_results_page.dart';
import '../features/chat/views/chat_screen.dart';
import '../data/models/search_result.dart'; // FIX: Add this import
import '../features/search/views/request_status_screen.dart';
import '../features/home/views/request_details_screen.dart';
import '../features/home/views/pharmacist_dashboard.dart';

class AppRoutes {
  // 1. Define all route names (constants)
  static const String initialRoute = '/';
  static const String intro = '/intro'; 
  static const String login = '/login';
  static const String pharmacistLogin = '/pharmacist_login'; // FIX 2: ADD THIS CONSTANT
  static const String signup = '/signup';
  static const String roleSelection = '/roleSelection';
  static const String userHome = '/userHome';
  static const String userProfile = '/userProfile';
  static const String searching = '/searching';
  static const String searchResults = '/searchResults';
  static const String chatScreen = '/chatScreen';
  static const String pharmacistHome = '/pharmacist_home';
  static const String pharmacistSignup = '/pharmacist_signup';
  static const String requestDetails = '/request_details';
  static const String requestStatus = '/request_status'; // Restore this

  // 2. Define the map that links route names to the widgets
  static Map<String, Widget Function(BuildContext)> routes = {
    
    initialRoute: (context) => const IntroPage(), 
    intro: (context) => const IntroPage(), 

    // Authentication Pages
    login: (context) => const UserLoginPage(),
    pharmacistLogin: (context) => const PharmacistLoginPage(), // FIX 3: Link the widget
    signup: (context) => const UserSignupPage(),
    roleSelection: (context) => const RoleSelectionPage(),
    
    // Home/User Pages
    userHome: (context) => const UserHomePage(),
    userProfile: (context) => const UserProfilePage(),
    
    // Pharmacist Pages
    pharmacistHome: (context) => const PharmacistDashboard(),
    
    requestDetails: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args == null) {
        return const PharmacistDashboard();
      }
      return RequestDetailsScreen(requestData: args);
    },

    // Searching Screen
    searching: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args == null || !args.containsKey('medicineName')) {
        return const UserHomePage();
      }
      return SearchingScreen(medicineName: args['medicineName'] as String);
    },
    
    // Search Results Page
    searchResults: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      
      if (args is List<dynamic>) {
        final List<SearchResult> results = args.map<SearchResult>((e) {
          if (e is SearchResult) return e;
          if (e is Map<String, dynamic>) return SearchResult.fromJson(e);
          return SearchResult.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        return SearchResultsPage(query: "Search Results", results: results);
      }
      return const UserHomePage();
    },

    // Chat Screen
    chatScreen: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args == null || !args.containsKey('chatRoomId') || !args.containsKey('partnerName') || !args.containsKey('partnerId')) {
        return const UserHomePage();
      }
      return ChatScreen(
        chatRoomId: args['chatRoomId'] as String,
        partnerName: args['partnerName'] as String,
        partnerId: args['partnerId'] as String,
      );
    },
    
    // Request Status Screen
    requestStatus: (context) => const RequestStatusScreen(),
  };
}