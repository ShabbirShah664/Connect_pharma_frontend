
import 'package:flutter/material.dart';
import '../features/auth/views/intro_page.dart';
import '../features/auth/views/user_login_page.dart';
import '../features/auth/views/user_signup_page.dart';
import '../features/auth/views/role_select_page.dart';
import '../features/home/views/user_home_page.dart';
import '../features/home/views/searching_screen.dart';
import '../features/home/views/response_page.dart';
import '../features/home/views/pharmacist_home_page.dart';
import '../features/home/views/pharmacist_requests_page.dart';
import '../features/home/views/pharmacist_chats_page.dart';
import '../features/home/views/pharmacist_orders_page.dart';
import '../features/profile/views/user_profile_page.dart';
import '../features/alarms/views/medicine_alarm_page.dart';
import '../features/auth/views/pharmacy_login_page.dart';
import '../features/auth/views/pharmacy_signup_page.dart';

import 'route_constants.dart';

class AppRoutes {
  static const String initialRoute = RouteConstants.initialRoute;

  static Map<String, Widget Function(BuildContext)> routes = {
    RouteConstants.initialRoute: (context) => const IntroPage(),
    
    RouteConstants.roleSelection: (context) => const RoleSelectPage(),
    
    RouteConstants.userLogin: (context) => const UserLoginPage(),
    RouteConstants.userSignup: (context) => const UserSignupPage(),
    
    RouteConstants.userHome: (context) => const UserHomePage(),
    RouteConstants.pharmacistHome: (context) => const PharmacistHomePage(),
    RouteConstants.pharmacistRequests: (context) => const PharmacistRequestsPage(),
    RouteConstants.pharmacistChats: (context) => const PharmacistChatsPage(),
    RouteConstants.pharmacistOrders: (context) => const PharmacistOrdersPage(),

    RouteConstants.searching: (context) => const SearchingScreen(),
    
    RouteConstants.responsePage: (context) {
       final args = ModalRoute.of(context)?.settings.arguments;
       if (args is String) {
         return ResponsePage(requestId: args);
       }
       return const Scaffold(body: Center(child: Text("Error: No Request ID provided")));
    },
    RouteConstants.userProfile: (context) => const UserProfilePage(),
    RouteConstants.medicineAlarms: (context) => const MedicineAlarmPage(),
    RouteConstants.pharmacyLogin: (context) => const PharmacyLoginPage(),
    RouteConstants.pharmacySignup: (context) => const PharmacySignupPage(),
  };
}