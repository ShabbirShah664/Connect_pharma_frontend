// lib/routes/app_routes.dart

import 'package:flutter/material.dart';
// Import all necessary view files
import '../features/auth/views/intro_page.dart';        // New Intro Page
import '../features/auth/views/user_login_page.dart';  // Corrected login page class name
import '../features/auth/views/user_signup_page.dart';
import '../features/auth/views/role_select_page.dart'; // Corrected role selection class name
import '../features/home/views/user_home_page.dart';
import '../features/home/views/user_profile_page.dart';
import '../features/home/views/searching_screen.dart';
import '../features/home/views/search_results_page.dart';
import '../features/chat/views/chat_screen.dart';
import '../data/models/search_result.dart'; // Ensure this model exists

class AppRoutes {
  // 1. Define all route names (constants)
  static const String initialRoute = '/';
  static const String intro = '/intro'; 
  static const String login = '/login';
  static const String signup = '/signup';
  static const String roleSelection = '/roleSelection';
  static const String userHome = '/userHome';
  static const String userProfile = '/userProfile';
  static const String searching = '/searching';
  static const String searchResults = '/searchResults';
  static const String chatScreen = '/chatScreen';


  // 2. Define the map that links route names to the widgets (the pages)
  static Map<String, Widget Function(BuildContext)> routes = {
    
    // The very first page the app loads
    initialRoute: (context) => const IntroPage(), 
    
    // Intro/Landing Page (where the user clicks 'Get Started')
    intro: (context) => const IntroPage(), 

    // Authentication Pages (using the corrected class names)
    login: (context) => const UserLoginPage(),
    signup: (context) => const UserSignupPage(),
    roleSelection: (context) => const RoleSelectionPage(),
    
    // Home/User Pages
    userHome: (context) => const UserHomePage(),
    userProfile: (context) => const UserProfilePage(),
    
    // Searching Screen (needs arguments for medicine name)
    searching: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args == null || !args.containsKey('medicineName')) {
        return const UserHomePage();
      }
      return SearchingScreen(medicineName: args['medicineName'] as String);
    },
    
    // Search Results Page (needs arguments for the list of results)
    searchResults: (context) {
      // Arguments should be a List of raw data (Map<String, dynamic>)
      final args = ModalRoute.of(context)?.settings.arguments as List<dynamic>?;
      if (args == null) {
        return const UserHomePage();
      }
      
      // Convert raw data maps into SearchResult model objects
      final List<SearchResult> results = args.map((e) => SearchResult.fromJson(e as Map<String, dynamic>)).toList();
      
      // FIX: Use 'results' as the named parameter to match the SearchResultsPage constructor
      //return SearchResultsPage(results: results);
    },

    // Chat Screen (needs arguments for chat identity)
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
  };
}